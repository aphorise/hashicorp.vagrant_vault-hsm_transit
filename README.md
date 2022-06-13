# HashiCorp `vagrant` demo of **`vault`** with Transit Benchmarking.

This repo contains a mock `Vagrantfile` of [Vault](https://www.vaultproject.io/docs/enterprise/hsm) for benchmark a [Transit mounts operations]() in three stages:
 - A. directly on the leader host (eg with `VAULT_ADDR='http://127.0.0.1:8200'`)
 - B. network settings ([TLS & `tls_disabled`](https://www.vaultproject.io/docs/configuration/listener/tcp#tls_disable)) via another Vault performance standby node or as close to leader host as possible (eg 0-1 hop away).
 - C. load-balancer settings via WAN or end-user facing environment

[Vault HSM Enterprise](https://www.vaultproject.io/docs/enterprise/hsm) using [SoftHSM](https://www.opendnssec.org/softhsm/) as an [auto-unseal type is possible](https://www.vaultproject.io/docs/configuration/seal/pkcs11) as detailed below.


## Prerequisites
The hardware & software requirements needed to use this repo is listed below.
 
#### HARDWARE & SOFTWARE
 - **RAM** **2**+ Gb Free at least (ensure you're not hitting SWAP either or are < 100Mb) needing more if using Consul.
 - **CPU** **4**+ Cores Free at least (4 or more per instance better)  needing more if you're using Consul.
 - **Network** interface allowing IP assignment and interconnection in VirtualBox bridged mode for all instances.
 - - adjust `sNET='en0: Wi-Fi (Wireless)'` in **`Vagrantfile`** to match your system.
 - [**Virtualbox**](https://www.virtualbox.org/) with [Virtualbox Guest Additions (VBox GA)](https://download.virtualbox.org/virtualbox/) correctly installed.
 - [**Vagrant**](https://www.vagrantup.com/)
 - **OPTIONAL**: :lock: An [enterprise license](https://www.hashicorp.com/products/vault/pricing/) is needed for [HSM Support](https://www.vaultproject.io/docs/enterprise/hsm) :lock:


## Excluded Systems & Network Considerations

All timing topologies related to network such as adaptor / link speeds (`dmesg | grep eth0 | grep up`) and [round-trip-time / delays](https://en.wikipedia.org/wiki/Round-trip_delay) should be known already. For example `traceroute` times between Vault hosts and and other intermediate network appliance between Users of Vault must be factored.

Benchmarks ought to start local to the Vault leader and directly on the same host where hardware specifications are noted and where network times or anomalies are excluded using loopback (`127.0.0.1`).

Thereafter - Tests should extend to other Vault performance standbys and eventually further to the periphery with each iteration of benchmarks onto load-balancers.


## Usage & Workflow
Refer to the contents of **`Vagrantfile`** & ensure network IP ranges specific to your setting then `vagrant up`.

To use Vault Enterprise HSM ensure that a license is set in **`vault_files/vault_license.txt`** and that the template adjust version specifics as documented in the `Vagrantfile` for the variable `vv` - eg: `VV1='VAULT_VERSION='+'1.10.4+ent.hsm'` ***prior to performing*** `vagrant up`.

```bash
# // FOR VAULT ENTERPRISE USE:
# // - SET or COPY LICENSE & SET DEFAULT SEAL in vault_files/vault_seal.hcl
# cp ... vault_files/vault_license.txt
# mv vault_files/vault_seal.hcl.hsm vault_files/vault_seal.hcl

# // adjust Vagrantfile values - eg:
# // - sCLUSTERA_IP_* & iCLUSTERA_IP_* values for your network
nano Vagrantfile ;

# // double check for any missed or unset values.
grep -E '192.168|.*_IP.*=|_sIP.*="' Vagrantfile

# // provision & wait 2...3 minutes
time vagrant up --provider virtualbox ;
# // ... output of provisioning steps.

vagrant global-status ; # should show running nodes
  # id       name        provider   state   directory
  # -------------------------------------------------------------------------------------
  # 59665b3  hsm1-vault1 virtualbox running /home/auser/hashicorp.vagrant_vault-hsm-transit

# // On a separate Terminal session check status of vault2 & cluster.
vagrant ssh hsm1-vault1 ;
  # ...

#vagrant@hsm1-vault1:~$ \
./vault_test_transit_sign.sh
  # RSA-2048 - SIZE OF PAYLOAD: 3859
  # 1 total time:  0.018134s
  # 2 total time:  0.017792s
  # 3 total time:  0.017713s
  # 4 total time:  0.018094s
  # 5 total time:  0.017521s
  # # // ...

exit ;
# // ---------------------------------------------------------------------------
# when completely done:
vagrant destroy -f hsm1-vault1 ; # ... destroy all - ORDER IMPORTANT
vagrant box remove -f debian/bullseye64 --provider virtualbox ; # ... delete box images
```


## Performance MacBook Pro (16-inch, 2019)
Host with 4 vCPU Threads (2.5Ghz), PCIE 3.0 NVME x4 Storage (1750.41 MB/sec) & 2GB RAM (2667 MHz DDR4). Time taken to provision Vagrant / VM: `1m59s`.

Using 30K Payload speeds **`2-4`** **milliseconds** for **rsa-2k** & maximum **`200-800`** **nanoseconds** for **ecdsa-256**.

| Descriptions         | (Total Time) | Response Time | Request TIme |
| --------------       | ------------ | ------------- | ------------ |
| 2ms rsa-2K 30K       | 0.002142079  | 43.648303532  | 43.646161453 |
| 2ms rsa-2K 30K       | 0.002190139  | 43.682337436  | 43.680147297 |
| 3ms rsa-2K 30K       | 0.002648878  | 43.718519655  | 43.715870777 |
| 3ms rsa-2K 30K       | 0.003459609  | 43.754248553  | 43.750788944 |
| 2ms rsa-2K 30K       | 0.002464871  | 43.791981318  | 43.789516447 |
| 800ns ecdsa-p256 30K | 0.00081795   | 44.220105604  | 44.219287654 |
| 213ns ecdsa-p256 30K | 0.000212515  | 44.254518305  | 44.25430579  |
| 231ns ecdsa-p256 30K | 0.000231339  | 44.287638483  | 44.287407144 |
| 269ns ecdsa-p256 30K | 0.000269323  | 44.318665843  | 44.31839652  |
| 218ns ecdsa-p256 30K | 0.000217878  | 44.352059333  | 44.351841455 |

Concurrent thirty (30x) requests with HMAC AUdit & 30K Payload maximum **`3-85`** **milliseconds** for **rsa-2k** & total duration of **`201`** **milliseconds** for complete batch.

| Descriptions         | (Total Time) | Average Time  | Maximum Time | Minimum Time |
| --------------       | ------------ | ------------- | ------------ | ------------ |
| 30 Concurrent 30K    | 0.201355133  | 0.0094805920  | 0.0842463249 | 0.0023292509 |


System info:

```
ps aux | wc -l
  # 99  // processes on host

lscpu
  # Architecture:                    x86_64
  # CPU(s):                          4
  # On-line CPU(s) list:             0-3
  # Thread(s) per core:              1
  # Model name:                      Intel(R) Core(TM) i9-9980HK CPU @ 2.40GHz
  # CPU MHz:                         2400.000
  # Hypervisor vendor:               KVM
  # Virtualization type:             full
  # L1d cache:                       128 KiB
  # L1i cache:                       128 KiB
  # L2 cache:                        1 MiB
  # L3 cache:                        64 MiB

free -mh
  #                total        used        free      shared  buff/cache   available
  # Mem:           1.9Gi       190Mi       1.5Gi       0.0Ki       283Mi       1.6Gi
  # Swap:             0B          0B          0B

fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --numjobs=1 --size=4g --iodepth=1 --runtime=60 --time_based --end_fsync=1
  # Run status group 0 (all jobs):
  # // HOST: WRITE: bw=20.4MiB/s (21.4MB/s), 20.4MiB/s-20.4MiB/s (21.4MB/s-21.4MB/s), io=1249MiB (1309MB), run=61123-61123msec
  # // VM:   WRITE: bw=30.8MiB/s (32.3MB/s), 30.8MiB/s-30.8MiB/s (32.3MB/s-32.3MB/s), io=2200MiB (2307MB), run=71361-71361msec

sudo hdparm -Ttv /dev/sda1
  #  Timing cached reads:   32440 MB in  1.99 seconds = 16304.92 MB/sec
  #  Timing buffered disk reads: 5888 MB in  3.00 seconds = 1962.49 MB/sec
```


## Performance AMD4750G (2020)
Host with 4 vCPU Threads (3.6Ghz), SATA-600 SSD Storage (600 MB/sec) & 2GB RAM (3200 MHz DDR4). Time taken to provision Vagrant / VM: `1m55s`.

Raw Audit in use with 30K Payload speeds **`1-2`** **milliseconds** for **rsa-2k** & maximum **`200-250`** **nanoseconds** for **ecdsa-256**.

| Descriptions         | (Total Time) | Response Time | Request TIme |
| --------------       | ------------ | ------------- | ------------ |
| 2ms rsa-2K 30K       | 0.0016947939 | 54.390936409  | 54.389241615 |
| 2ms rsa-2K 30K       | 0.0016818299 | 54.414009625  | 54.412327795 |
| 3ms rsa-2K 30K       | 0.0016958459 | 54.437240026  | 54.43554418  |
| 3ms rsa-2K 30K       | 0.0017228959 | 54.460534407  | 54.458811511 |
| 2ms rsa-2K 30K       | 0.0017377539 | 54.483883932  | 54.482146178 |
| 800ns ecdsa-p256 30K | 0.0002483669 | 54.76745683   | 54.767208463 |
| 213ns ecdsa-p256 30K | 0.0002302919 | 54.789580351  | 54.789350059 |
| 231ns ecdsa-p256 30K | 0.0002069089 | 54.812167494  | 54.811960585 |
| 269ns ecdsa-p256 30K | 0.0002070900 | 54.834334548  | 54.834127539 |
| 218ns ecdsa-p256 30K | 0.0002354229 | 54.856198622  | 54.855963199 |

Concurrent thirty (30x) requests with HMAC AUdit & 30K Payload maximum **`1-65`** **milliseconds** for **rsa-2k** & total duration of **`138`** **milliseconds** for complete batch.

| Descriptions         | (Total Time) | Average Time  | Maximum Time | Minimum Time |
| --------------       | ------------ | ------------- | ------------ | ------------ |
| 30 Concurrent 30K    | 0.1383543640 | 0.0078760318  | 0.0655252609 | 0.0017869849 |


System info:

```
ps aux | wc -l
  # 99  // processes on host

lscpu
  # Architecture:                    x86_64
  # CPU(s):                          4
  # On-line CPU(s) list:             0-3
  # Thread(s) per core:              1
  # Model name:                      AMD Ryzen 7 PRO 4750G with Radeon Graphics
  # CPU MHz:                         3593.238
  # Hypervisor vendor:               KVM
  # Virtualization type:             full
  # L1d cache:                       128 KiB
  # L1i cache:                       128 KiB
  # L2 cache:                        2 MiB
  # L3 cache:                        8 MiB

free -mh
  #                total        used        free      shared  buff/cache   available
  # Mem:           1.9Gi       163Mi       612Mi       0.0Ki       1.2Gi       1.6Gi
  # Swap:             0B          0B          0B

fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --numjobs=1 --size=4g --iodepth=1 --runtime=60 --time_based --end_fsync=1
  # // HOST: WRITE: bw=148MiB/s (155MB/s), 148MiB/s-148MiB/s (155MB/s-155MB/s), io=10.1GiB (10.9GB), run=70009-70009msec
  # // VM:   WRITE: bw=65.8MiB/s (68.0MB/s), 65.8MiB/s-65.8MiB/s (68.0MB/s-68.0MB/s), io=3965MiB (4158MB), run=60282-60282msec

sudo hdparm -Ttv /dev/sda1
  #  Timing cached reads:   30296 MB in  1.98 seconds = 15294.85 MB/sec
  #  Timing buffered disk reads: 396 MB in  3.01 seconds = 131.54 MB/sec
```


## Notes
This is intended as a mere practise / training exercise.

Taken from:
 - [github.com/aphorise/hashicorp.vagrant_vault-hsm](https://github.com/aphorise/hashicorp.vagrant_vault-hsm)

------
