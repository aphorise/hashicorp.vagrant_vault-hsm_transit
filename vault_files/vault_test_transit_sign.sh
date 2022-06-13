#!/usr/bin/env bash
if [[ ! ${VAULT_ADDR+x} ]] ; then VAULT_ADDR='http://127.0.0.1:8200' ; fi ;
if [[ ! ${VAULT_TOKEN+x} ]] ; then printf 'VAULT_TOKEN not set.\n' ; exit 1 ; fi ;

# // 3.6Kb Payload
PAYLOAD='{ "$schema": "http://json-schema.org/draft-04/schema#", "title": "Outbound Payment Response", "type": "object", "additionalProperties": false, "properties": { "id": { "type": "string", "pattern": "^.*ABCDEFS+.*$", "maxLength": 36 }, "organisationId": { "type": "string", "pattern": "^.*ABCDEFS+.*$", "minLength": 1 }, "payment": { "$ref": "#/definitions/OutboundPayment" }, "paymentSubmission": { "$ref": "#/definitions/PaymentSubmission" }, "paymentStatus": { "$ref": "#/definitions/PaymentStatus" } }, "required": [ "id", "organisationId" ], "definitions": { "OutboundPayment": { "type": "object", "additionalProperties": false, "properties": { "id": { "type": "string", "pattern": "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", "minLength": 1 }, "processingDate": { "type": "string", "pattern": "^.*ABCDEFS+.*$", "minLength": 1 }, "currency": { "type": "string", "pattern": "GBP", "minLength": 1 }, "amount": { "type": "string", "pattern": "^[0-9]{1,13}ABCDEF.[0-9]{2}$", "minLength": 1 }, "reference": { "type": "string", "pattern": "^[0-9a-zA-Z/ABCDEF-?:().,AB+#=!ABAB%&*<>;{@ ]{1,18}$|^NULL$" }, "numericReference": { "type": "string", "pattern": "^[0-9 ]{4}$|^NULL$|^ABCDEFs*$" }, "transactionReferenceNumber": { "type": "string", "pattern": "^[A-Za-z0-9 ABCDEF/ABCDEF-?:ABCDEF(ABCDEF)ABCDEF.,’ABCDEF+ABCDEF#ABCDEF=ABCDEF!ABCDEF”%&ABCDEF*ABCDEF<ABCDEF>;ABCDEF{@]{1,18}$", "minLength": 1 }, "debtorAccount": { "$ref": "#/definitions/Account" }, "creditorAccount": { "$ref": "#/definitions/Account" }, "schemePaymentType": { "type": "string", "pattern": "ImmediatePayment|StandingOrder", "minLength": 1 }, "schemePaymentSubType": { "type": "string", "pattern": "TelephoneBanking|InternetBanking|BranchInstruction|Letter|Email|MobilePaymentsService", "minLength": 1 }, "endToEndReference": { "type": "string", "pattern": "^[A-Za-z0-9 ABCDEF/ABCDEF-?:ABCDEF(ABCDEF)ABCDEF.,’ABCDEF+ABCDEF#ABCDEF=ABCDEF!ABCDEF”%&ABCDEF*ABCDEF<ABCDEF>;ABCDEF{@]{1,31}$|^NULL$" }, "regulatoryReporting": { "type": "string", "pattern": "^[A-Za-z0-9 /ABCDEF-]{1,105}$|^NULL$" }, "remittanceInformation": { "type": "string", "pattern": "^[0-9a-zA-Z/ABCDEF-?:().,AB+#=!ABAB%&*<>;{@ ]{1,140}$|^NULL$" }, "paymentPurpose": { "type": "string" }, "paymentType": { "type": "string" }, "paymentScheme": { "type": "string" }, "fpid": { "type": "string" } }, "required": [ "id", "processingDate", "currency", "amount", "transactionReferenceNumber", "debtorAccount", "creditorAccount", "schemePaymentType", "schemePaymentSubType" ] }, "Account": { "type": "object", "additionalProperties": false, "properties": { "accountName": { "type": "string", "pattern": "^[A-Za-z -?:)AB(.,’+#=!%&*{<>;@]{0,40}$", "minLength": 1 }, "identification": { "type": "string", "pattern": "ABCDEFd+", "minLength": 14, "maxLength": 14 }, "schemeName": { "type": "string", "pattern": "SortCodeAccountNumber|UK.OBIE.SortCodeAccountNumber", "minLength": 1 }, "address": { "type": "string" } }, "required": [ "accountName", "identification", "schemeName" ] }, "PaymentSubmission": { "type": "object", "additionalProperties": false, "properties": { "id": { "type": "string", "pattern": "^.*ABCDEFS+.*$", "minLength": 1 }, "submissionDatetime": { "type": "string" }, "submissionStartDateTime": { "type": "string" }, "status": { "type": "string" }, "statusReason": { "type": "string" }, "schemeStatusCode": { "type": "string" }, "schemeStatusCodeDescription": { "type": "string" }, "settlementDate": { "type": "string" }, "settlementCycle": { "type": "string" }, "redirectedAccountNumber": { "type": "string" }, "redirectedBankId": { "type": "string" } }, "required": [ "id" ] }, "PaymentStatus": { "type": "object", "additionalProperties": false, "properties": { "code": { "type": "string" }, "reasonCode": { "type": "string" }, "reasonText": { "type": "string" } } } } }' ;
# // 30Kb Payload
BIG_DATA='1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_+1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ_" }' ;

PAYLOAD_BIG='{ "raw_data" : "' ;

vault secrets enable -path=transit_std transit ;
vault write -f transit_std/keys/transactions_key_rsa2k type=rsa-2048 ;
vault write -f transit_std/keys/transactions_key_ecdsa-p256 type=ecdsa-p256 ;

# // TEST 1 - regular hmac audit device
vault audit enable -path=raw_audit file file_path=/vault/vaudit_hmac_rsa.json ;
printf "RSA-2048 HMAC AUDIT - SIZE OF PAYLOAD: $(echo ${PAYLOAD} | wc -c)\n" ;
for iX in {1..5} ; do
	curl -k -L -o /dev/null -s -w "${iX} total time:  %{time_total}s\n" -X POST -H "X-Vault-Token: ${VAULT_TOKEN}" -d "${PAYLOAD}" ${VAULT_ADDR}/v1/transit_std/sign/transactions_key_rsa2k
done ;
printf "......................................\n" ;
vault audit disable raw_audit 2>&1 > /dev/null ;

# // TEST 1 - RSA with raw audit device - 3.6K & 30K payloads
vault audit enable -path=raw_audit file file_path=/vault/vaudit_raw_rsa.json log_raw=true ;
printf "RSA-2048 RAW AUDIT - SIZE OF PAYLOAD: $(echo ${PAYLOAD} | wc -c)\n" ;
for iX in {1..5} ; do
	curl -k -L -o /dev/null -s -w "${iX} total time:  %{time_total}s\n" -X POST -H "X-Vault-Token: ${VAULT_TOKEN}" -d "${PAYLOAD}" ${VAULT_ADDR}/v1/transit_std/sign/transactions_key_rsa2k
done ;
printf "......................................\n" ;

PAYLOAD_BIG_TMP="${PAYLOAD_BIG}0_${BIG_DATA}" ;
printf "RSA-2048 RAW AUDIT - SIZE OF PAYLOAD: $(echo ${PAYLOAD_BIG_TMP} | wc -c)\n" ;
for iX in {1..5} ; do
	PAYLOAD_BIG_TMP="${PAYLOAD_BIG}${iX}_${BIG_DATA}" ;
	curl -k -L -o /dev/null -s -w "${iX} total time:  %{time_total}s\n" -X POST -H "X-Vault-Token: ${VAULT_TOKEN}" -d "${PAYLOAD_BIG_TMP}" ${VAULT_ADDR}/v1/transit_std/sign/transactions_key_rsa2k
done ;
printf "......................................\n" ;
vault audit disable raw_audit 2>&1 > /dev/null ;

# // TEST 2 - ECDSA with raw audit device - 3.6K & 30K payloads
vault audit enable -path=raw_audit file file_path=/vault/vaudit_raw_ecdsa.json log_raw=true ;
printf "ECDSA-256 RAW AUDIT - SIZE OF PAYLOAD: $(echo ${PAYLOAD} | wc -c)\n" ;
for iX in {1..5} ; do
	curl -k -L -o /dev/null -s -w "${iX} total time:  %{time_total}s\n" -X POST -H "X-Vault-Token: ${VAULT_TOKEN}" -d "${PAYLOAD}" ${VAULT_ADDR}/v1/transit_std/sign/transactions_key_ecdsa-p256
done ;
printf "......................................\n" ;

PAYLOAD_BIG_TMP="${PAYLOAD_BIG}0_${BIG_DATA}" ;
printf "ECDSA-256 RAW AUDIT - SIZE OF PAYLOAD: $(echo ${PAYLOAD_BIG_TMP} | wc -c)\n" ;
for iX in {1..5} ; do
	PAYLOAD_BIG_TMP="${PAYLOAD_BIG}${iX}_${BIG_DATA}" ;
	curl -k -L -o /dev/null -s -w "${iX} total time:  %{time_total}s\n" -X POST -H "X-Vault-Token: ${VAULT_TOKEN}" -d "${PAYLOAD_BIG_TMP}" ${VAULT_ADDR}/v1/transit_std/sign/transactions_key_ecdsa-p256
done ;
printf "......................................\n" ;
vault audit disable raw_audit 2>&1 > /dev/null ;

SECONDS=0
# // TEST 3 - RSA with raw audit device & 30 30K payload of request ;
vault audit enable -path=raw_audit file file_path=/vault/vaudit_rsa_30.json ;
PAYLOAD_BIG_TMP="${PAYLOAD_BIG}0_${BIG_DATA}" ;
printf "CONCURRENT 30X LOAD TEST WITH RSA-2048 HMAC AUDIT & PAYLOAD OF: $(echo ${PAYLOAD_BIG_TMP} | wc -c)\n" ;
for iX in {1..30} ; do
	PAYLOAD_BIG_TMP="${PAYLOAD_BIG}${iX}${BIG_DATA}" ;
	curl -s -k -L -o /dev/null -X POST -H "X-Vault-Token: ${VAULT_TOKEN}" -d "${PAYLOAD_BIG_TMP}" ${VAULT_ADDR}/v1/transit_std/sign/transactions_key_rsa2k &
done ;
printf "......................................\n" ;

wait # wait for all bg operations to complete
printf "CONCURENT Requests Took: ${SECONDS} seconds.\n" ;

vault audit disable raw_audit 2>&1 > /dev/null ;
vault secrets disable transit_std 2>&1 > /dev/null ;

# // for reference:
# time curl -X POST -H "X-Vault-Token: ${VAULT_TOKEN}" -d "${PAYLOAD}" ${VAULT_ADDR}/v1/transit_std/sign/transactions_key_ecdsa-p256
# curl -o /dev/null -s -w "dnslookup:  %{time_namelookup}s\ntcpconnect: %{time_connect}s\nappconnect: %{time_appconnect}s\n     pretx: %{time_pretransfer}s\n  redirect: %{time_redirect}s\n   beingtx: %{time_starttransfer}s\n-------------------------\n     total:  %{time_total}s\n" -X POST -H "X-Vault-Token: ${VAULT_TOKEN}" -d "${PAYLOAD}" ${VAULT_ADDR}/v1/transit_std/sign/transactions_key_rsa2k

# sudo jq -r 'select(.type=="request")|.time' /vault/vaudit_raw_rsa.json
# sudo jq -r 'select(.type=="response")|.time' /vault/vaudit_raw_rsa.json
# sudo jq -r 'select(.type=="request")|.time' /vault/vaudit_raw_ecdsa.json
# sudo jq -r 'select(.type=="response")|.time' /vault/vaudit_raw_ecdsa.json
# sudo jq -r 'select(.type=="request")|.time' /vault/vaudit_rsa_30.json
# sudo jq -r 'select(.type=="response")|.time' /vault/vaudit_rsa_30.json

printf "End of Script.\n" ;