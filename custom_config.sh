#!/bin/bash

DOMAIN_NAME="example.com"
ORD_NAME0_C="Orderer"
ORG_1_C="Org1"
ORG_2_C="Org2"
ORG_3_C="Org3"
ORG_4_C="Org4"


ORG_1="org1"
ORG_2="org2"
ORG_3="org3"
ORG_4="org4"


PCOUNT="3"
PEER_NAME0="peer0"
PEER_NAME1="peer1"
PEER_NAME2="peer2"

ORD_NAME0="orderer"
ORD_NAME1="orderer2"
ORD_NAME2="orderer3"
CA_ORG0="ca"
CA_ORG1="ca1"
CA_ORG2="ca2"
CHANNEL_NAME1="mychannel"
CHANNEL_NAME2="CH_NAME2"


### IF MultiNode Setup by #####

HOST_IP1="192.168.1.1"
HOST_IP2="192.168.1.2"
HOST_IP3="192.168.1.3"

cp configtx.yamlorg  configtx.yaml
cp crypto-config.yamlorg crypto-config.yaml

set -x
####Crypto-config.yml#######
sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" crypto-config.yaml
sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" crypto-config.yaml

sed -i -e "s/{ORD_NAME0_C}/$ORD_NAME0_C/g" crypto-config.yaml
sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" crypto-config.yaml
sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" crypto-config.yaml
sed -i -e "s/{ORG_3_C}/$ORG_3_C/g" crypto-config.yaml

sed -i -e "s/{ORG_1}/$ORG_1/g" crypto-config.yaml
sed -i -e "s/{ORG_2}/$ORG_2/g" crypto-config.yaml
sed -i -e "s/{ORG_3}/$ORG_3/g" crypto-config.yaml
sed -i -e "s/{PCOUNT}/$PCOUNT/g" crypto-config.yaml

####configtx.yml#######
sed -i -e "s/{DOMAIN_NAME}/$DOMAIN_NAME/g" configtx.yaml
sed -i -e "s/{ORD_NAME0}/$ORD_NAME0/g" configtx.yaml
sed -i -e "s/{ORG_1}/$ORG_1/g" configtx.yaml
sed -i -e "s/{ORG_2}/$ORG_2/g" configtx.yaml
sed -i -e "s/{ORG_3}/$ORG_3/g" configtx.yaml
sed -i -e "s/{PEER_NAME0}/$PEER_NAME0/g" configtx.yaml
sed -i -e "s/{PEER_NAME1}/$PEER_NAME1/g" configtx.yaml
sed -i -e "s/{PEER_NAME2}/$PEER_NAME2/g" configtx.yaml

sed -i -e "s/{ORD_NAME0_C}/$ORD_NAME0_C/g" configtx.yaml
sed -i -e "s/{ORG_1_C}/$ORG_1_C/g" configtx.yaml
sed -i -e "s/{ORG_2_C}/$ORG_2_C/g" configtx.yaml
sed -i -e "s/{ORG_3_C}/$ORG_3_C/g" configtx.yaml

###### for Different Host ########

sed -i -e "s/{IP-HOST1}/$HOST1/g" configtx.yaml
sed -i -e "s/{IP-HOST2}/$HOST2/g" configtx.yaml
sed -i -e "s/{IP-HOST3}/$HOST3/g" configtx.yaml
###################################

ORG1KEY="$(ls crypto-config/peerOrganizations/$ORG_1.$DOMAIN_NAME/ca/ | grep 'sk$')"
sed -i -e "s/{ORG1-CA-KEY}/$ORG1KEY/g" docker-compose.yml

ORG2KEY="$(ls crypto-config/peerOrganizations/$ORG_3.$DOMAIN_NAME/ca/ | grep 'sk$')"
sed -i -e "s/{ORG2-CA-KEY}/$ORG2KEY/g" docker-compose.yml

ORG3KEY="$(ls crypto-config/peerOrganizations/$ORG_3.$DOMAIN_NAME/ca/ | grep 'sk$')"
sed -i -e "s/{ORG3-CA-KEY}/$ORG1KEY/g" docker-compose.yml







set +x
