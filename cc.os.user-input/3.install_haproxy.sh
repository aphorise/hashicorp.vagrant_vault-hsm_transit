#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive ;
set -eu ; # abort this script when a command fails or an unset variable is used.
#set -x ; # echo all the executed commands.

# // FOR LINUX BINARIES SEE: https://haproxy.debian.net/
if [[ $(uname -ar) == *"Debian"* ]] ; then
	if ! [[ -s /etc/apt/sources.list.d/haproxy.list ]] ; then
		curl -s https://haproxy.debian.net/bernat.debian.org.gpg | sudo APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - ;
		printf 'deb http://haproxy.debian.net bullseye-backports-2.6 main\n' > /etc/apt/sources.list.d/haproxy.list ;
	fi ;
else
	printf 'ERROR: OS Not supported for HAProxy install.' ;
	exit 1;
fi ;

sudo apt-get update 2>&1> /dev/null && sudo apt-get -yqq install haproxy=2.6.\* 2>&1> /dev/null ;
if (($? == 0)) ; then printf 'INSTALLED: Haproxy 2.x\n' ; fi ;

mv /etc/haproxy/haproxy.cfg /etc/haproxy/original.haproxy.cfg ;

printf '%s' '''
HTTP/1.0 200 OK
Cache-Control: no-cache
Connection: close
Content-Type: text/html

<html><body><h1>VAULT LOAD-BALANCER</h1>
</body></html>
''' > /etc/haproxy/errors/200.http ;

printf '%s' '''global
 log /dev/log    local0
 log /dev/log    local1 notice
 chroot /var/lib/haproxy
 stats socket /run/haproxy/admin.sock mode 666 level admin
 stats timeout 30s
 user haproxy
 group haproxy
 daemon
 pidfile /var/run/haproxy.pid
 # Default SSL material locations
 ca-base /usr/lib/ssl/certs
 crt-base /usr/lib/ssl/private
 tune.ssl.default-dh-param 2048
 tune.maxaccept 4096
 ssl-server-verify required
 ssl-default-bind-options no-sslv3
 ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
 ssl-default-server-options no-sslv3
 ssl-default-server-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS

defaults
 log     global
 mode    http
 option  httplog clf
 option  dontlognull
 timeout connect 5000
 timeout client  5000
 timeout server  5000
# option forwardfor
 maxconn 900000
 option httpclose
 option httpchk
# http-check expect status 200
 errorfile 200 /etc/haproxy/errors/200.http
 errorfile 400 /etc/haproxy/errors/400.http
 errorfile 403 /etc/haproxy/errors/403.http
 errorfile 408 /etc/haproxy/errors/408.http
 errorfile 500 /etc/haproxy/errors/500.http
 errorfile 502 /etc/haproxy/errors/502.http
 errorfile 503 /etc/haproxy/errors/503.http
 errorfile 504 /etc/haproxy/errors/504.http
#//--------------------------------

# // HAProxy peers
# peer lb1 1.2.3.4:1024
# peer lb2 2.3.4.5:1024
#//--------------------------------

frontend inwebs_https
# HTTP all traffic to HTTPS
 redirect scheme https if !{ ssl_fc }
 bind *:80
 bind *:443 ssl crt /usr/lib/ssl/haproxy_cert.pem ca-file /usr/lib/ssl/cacert.crt
 #bind *:443 verify required ssl crt /usr/lib/ssl/haproxy_cert.pem ca-file /usr/lib/ssl/cacert.crt
 compression algo gzip
 compression type text/html text/plain text/javascript application/javascript application/xml text/css
 log-format %ci\ [%T]\ %{+Q}r\ %ST\ %B\ %{+Q}hrl\ %{+Q}hsl\ %U\ %{+Q}b\ %{+Q}s
 log /dev/log    local0 info
 capture request header User-Agent len 8192
 capture request header Accept-language len 64
 #//check for host header is present with the right target
 #acl url_VAULT hdr(host) -i vault.tld.local
 # acl url_VAULT_DIRECT hdr(host) -i vault1.tld.local vault2.tld.local vault3.tld.local
 # use_backend DC1_VAULT_PRIMARY_API if url_VAULT or url_VAULT_DIRECT
 default_backend DC1_VAULT_PRIMARY_API
 # // NON-TARGETTED CATCH ALL:
 # default_backend UFO
#//--------------------------------

frontend inwebs_rpc
 mode tcp
 bind *:8201
 log-format %ci:%cp\ [%t]\ %ft\ %b/%s\ %Tw/%Tc/%Tt\ %B\ %ts\ %ac/%fc/%bc/%sc/%rc\ %sq/%bq
 use_backend DC1_VAULT_PRIMARY_RPC

backend UFO
 http-request deny deny_status 200
#if ! valid_method
# http-send-name-header Host
# server UFO.busybox.tld 127.0.0.1:58800
#//--------------------------------

backend DC1_VAULT_PRIMARY_API
 #stick-table type ip size 20k
 #stick on src
 #http-request add-header X-Forwarded-Proto https if { ssl_fc }  # optional but can be handy
 option forwardfor
 option persist
 http-send-name-header Host
 option httpchk GET /v1/kv/data/health-check HTTP/1.1
 http-check expect status 400,403
# http-check expect status 307  # // default vault response with basic check
# http-check expect rstring {"errors":["permission denied"]}
# OLDER 2.1 SYNTAX: http-check expect status 400 rstring {"errors":["missing client token"]}

 # // based on host header target vault-server
 use-server vault1 if { req.hdr(host) vault1.tld.local }
 server vault1 192.168.178.183:8200 check
 use-server vault2 if { req.hdr(host) vault2.tld.local }
 server vault2 192.168.178.182:8200 check
 use-server vault3 if { req.hdr(host) vault3.tld.local }
 server vault3 192.168.178.181:8200 check
 # // ^^ adjust or put others as needed.
 # // for a per target response 
 # http-request return 503 content-type text/plain string "down" if { req.hdr(host) vault1.tld.local } !{ serv_is_up(DC1_VAULT_PRIMARY_API/vault1) }
#//--------------------------------

backend DC1_VAULT_PRIMARY_RPC
 mode    tcp
 option httpchk GET /v1/sys/health HTTP/1.1
 http-check send hdr Host www hdr User-agent LB-Check
# http-check expect status 200
 server vault1 192.168.178.183:8201 check port 8200
 server vault2 192.168.178.182:8201 check port 8200
 server vault3 192.168.178.181:8201 check port 8200
 # ^^ adjust or put others as needed.
#//--------------------------------

defaults

listen haadmin
 bind *:60100
 mode http
 timeout connect 5000
 timeout client  5000
 timeout server  5000
 log /dev/log    local0
 no log
 stats uri /
 stats hide-version
 stats refresh 4
 stats show-desc Vault (LB)
 stats realm Vault Load-Balancer
''' > /etc/haproxy/haproxy.cfg ;

sudo service haproxy restart > /dev/null ;
