#!/bin/bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Usage() {
        echo ""
        echo "Usage: ./createPeerAdminCard.sh [-h host] [-n]"
        echo ""
        echo "Options:"
        echo -e "\t-h or --host:\t\t(Optional) name of the host to specify in the connection profile"
        echo -e "\t-n or --noimport:\t(Optional) don't import into card store"
        echo ""
        echo "Example: ./createPeerAdminCard.sh"
        echo ""
        exit 1
}

Parse_Arguments() {
        while [ $# -gt 0 ]; do
                case $1 in
                        --help)
                                HELPINFO=true
                                ;;
                        --host | -h)
                shift
                                HOST="$1"
                                ;;
            --noimport | -n)
                                NOIMPORT=true
                                ;;
                esac
                shift
        done
}

HOST=localhost
Parse_Arguments $@

if [ "${HELPINFO}" == "true" ]; then
    Usage
fi

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "${HL_COMPOSER_CLI}" ]; then
  HL_COMPOSER_CLI=$(which composer)
fi

echo
# check that the composer command exists at a version >v0.16
COMPOSER_VERSION=$("${HL_COMPOSER_CLI}" --version 2>/dev/null)
COMPOSER_RC=$?

if [ $COMPOSER_RC -eq 0 ]; then
    AWKRET=$(echo $COMPOSER_VERSION | awk -F. '{if ($2<20) print "1"; else print "0";}')
    if [ $AWKRET -eq 1 ]; then
        echo Cannot use $COMPOSER_VERSION version of composer with fabric 1.2, v0.20 or higher is required
        exit 1
    else
        echo Using composer-cli at $COMPOSER_VERSION
    fi
else
    echo 'No version of composer-cli has been detected, you need to install composer-cli at v0.20 or higher'
    exit 1
fi

# Grab the file names of the keystore keys
ORG1KEY="$(ls composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/)"
ORG2KEY="$(ls composer/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/)"


# need to get the certificate

cat << EOF > org1onlyconnection.json
{
    "name": "pocnet1-org1-only",
    "x-type": "hlfv1",
    "x-commitTimeout": 300,
    "version": "1.0.0",
    "client": {
        "organization": "Org1",
        "connection": {
            "timeout": {
                "peer": {
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer.example.com"
            ],
            "peers": {
                "peer0.org1.example.com": {},
                "peer1.org1.example.com": {},
                "peer2.org1.example.com": {}
            }
        }
    },
    "organizations": {
        "Org1": {
            "mspid": "Org1MSP",
            "peers": [
                "peer0.org1.example.com",
                "peer1.org1.example.com",
                "peer2.org1.example.com"
            ],
            "certificateAuthorities": [
                "ca.org1.example.com"
            ]
        }
    },
    "orderers": {
        "orderer.example.com": {
            "url": "grpc://localhost:7050"
        }
    },
    "peers": {
        "peer0.org1.example.com": {
            "url": "grpc://localhost:7051",
            "eventUrl": "grpc://localhost:7053"
        },
        "peer1.org1.example.com": {
            "url": "grpc://localhost:8051",
            "eventUrl": "grpc://localhost:8053"
        },
        "peer1.org1.example.com": {
            "url": "grpc://localhost:9051",
            "eventUrl": "grpc://localhost:9053"
        }
    },
    "certificateAuthorities": {
        "ca.org1.example.com": {
            "url": "http://localhost:7054",
            "caName": "ca.org1.example.com"
        }
    }
}

EOF

cat << EOF > org1connection.json
{
    "name": "pocnet1-org1",
    "x-type": "hlfv1",
    "x-commitTimeout": 300,
    "version": "1.0.0",
    "client": {
        "organization": "Org1",
        "connection": {
            "timeout": {
                "peer": {
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer.example.com"
            ],
            "peers": {
                "peer0.org1.example.com": {},
                "peer1.org1.example.com": {},
                "peer2.org1.example.com": {},
                "peer0.org2.example.com": {},
                "peer1.org2.example.com": {},
                "peer2.org2.example.com": {}
            }
        }
    },
    "organizations": {
        "Org1": {
            "mspid": "Org1MSP",
            "peers": [
                "peer0.org1.example.com",
                "peer1.org1.example.com",
                "peer2.org1.example.com"
            ],
            "certificateAuthorities": [
                "ca.org1.example.com"
            ]
        }
    },
    "orderers": {
        "orderer.example.com": {
            "url": "grpc://localhost:7050"
        }
    },
    "peers": {
        "peer0.org1.example.com": {
            "url": "grpc://localhost:7051",
            "eventUrl": "grpc://localhost:7053"
        },
        "peer1.org1.example.com": {
            "url": "grpc://localhost:8051",
            "eventUrl": "grpc://localhost:8053"
        },
        "peer1.org1.example.com": {
            "url": "grpc://localhost:9051",
            "eventUrl": "grpc://localhost:9053"
        },
          "peer0.org2.example.com": {
            "url": "grpc://HOST2_IP:10051",
            "eventUrl": "grpc://HOST2_IP:10053"
        },
        "peer1.org2.example.com": {
            "url": "grpc://HOST2_IP:11051",
            "eventUrl": "grpc://HOST2_IP:11053"
        },
        "peer2.org2.example.com": {
            "url": "grpc://HOST2_IP:12051",
            "eventUrl": "grpc://HOST2_IP:12053"
        }
    },
    "certificateAuthorities": {
        "ca.org1.example.com": {
            "url": "http://localhost:7054",
            "caName": "ca.org1.example.com"
        }
    }
}

EOF

PRIVATE_KEY="${DIR}"/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/"${ORG1KEY}"
CERT="${DIR}"/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem

#rm /tmp/PeerAdmin*


if composer card list -c PeerAdmin@pocnet1-org1-only > /dev/null; then
    composer card delete -c PeerAdmin@pocnet1-org1-only
fi

if composer card list -c PeerAdmin@pocnet1-org1 > /dev/null; then
    composer card delete -c PeerAdmin@pocnet1-org1
fi

composer card create -p edexaorg1onlyconnection.json -u PeerAdmin -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file /tmp/PeerAdmin@pocnet1-org1-only.card
composer card import --file /tmp/PeerAdmin@pocnet1-org1-only.card

composer card create -p edexaorg1connection.json -u PeerAdmin -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file /tmp/PeerAdmin@pocnet1-org1.card
composer card import --file /tmp/PeerAdmin@pocnet1-org1.card


#rm -rf org1onlyconnection.json

cat << EOF > org2onlyconnection.json
{
    "name": "pocnet1-org2-only",
    "x-type": "hlfv1",
    "x-commitTimeout": 300,
    "version": "1.0.0",
    "client": {
        "organization": "Org2",
        "connection": {
            "timeout": {
                "peer": {
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer.example.com"
            ],
            "peers": {
                "peer0.org2.example.com": {},
                "peer1.org2.example.com": {},
                "peer2.org2.example.com": {}
            }
        }
    },
    "organizations": {
        "Org2": {
            "mspid": "Org2MSP",
            "peers": [
                "peer0.org2.example.com",
                "peer1.org2.example.com",
                "peer2.org2.example.com"
            ],
            "certificateAuthorities": [
                "ca.org2.example.com"
            ]
        }
    },
    "orderers": {
        "orderer.example.com": {
            "url": "grpc://13.233.49.98:7050"
        }
    },
    "peers": {
          "peer0.org2.example.com": {
            "url": "grpc://HOST2_IP:10051",
            "eventUrl": "grpc://HOST2_IP:10053"
        },
        "peer1.org2.example.com": {
            "url": "grpc://HOST2_IP:11051",
            "eventUrl": "grpc://HOST2_IP:11053"
        },
        "peer2.org2.example.com": {
            "url": "grpc://HOST2_IP:12051",
            "eventUrl": "grpc://HOST2_IP:12053"
        }
    },
    "certificateAuthorities": {
        "ca.org2.example.com": {
            "url": "http://HOST2_IP:8054",
            "caName": "ca.org2.example.com"
        }
    }
}
EOF

cat << EOF > edexaorg2connection.json
{
    "name": "pocnet1-org2",
    "x-type": "hlfv1",
    "x-commitTimeout": 300,
    "version": "1.0.0",
    "client": {
        "organization": "Org2",
        "connection": {
            "timeout": {
                "peer": {
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
    "channels": {
        "composerchannel": {
            "orderers": [
                "orderer.example.com"
            ],
            "peers": {
                "peer0.org1.example.com": {},
                "peer1.org1.example.com": {},
                "peer2.org1.example.com": {},
                "peer0.org2.example.com": {},
                "peer1.org2.example.com": {},
                "peer2.org2.example.com": {}
            }
        }
    },
    "organizations": {
        "Org2": {
            "mspid": "Org2MSP",
            "peers": [
                "peer0.org2.example.com",
                "peer1.org2.example.com",
                "peer2.org2.example.com"
            ],
            "certificateAuthorities": [
                "ca.org2.example.com"
            ]
        }
    },
    "orderers": {
        "orderer.example.com": {
            "url": "grpc://13.233.49.98:7050"
        }
    },
    "peers": {
        "peer0.org1.example.com": {
            "url": "grpc://localhost:7051",
            "eventUrl": "grpc://localhost:7053"
        },
        "peer1.org1.example.com": {
            "url": "grpc://localhost:8051",
            "eventUrl": "grpc://localhost:8053"
        },
        "peer1.org1.example.com": {
            "url": "grpc://localhost:9051",
            "eventUrl": "grpc://localhost:9053"
        },
          "peer0.org2.example.com": {
            "url": "grpc://HOST2_IP:10051",
            "eventUrl": "grpc://HOST2_IP:10053"
        },
        "peer1.org2.example.com": {
            "url": "grpc://HOST2_IP:11051",
            "eventUrl": "grpc://HOST2_IP:11053"
        },
        "peer2.org2.example.com": {
            "url": "grpc://HOST2_IP:12051",
            "eventUrl": "grpc://HOST2_IP:12053"
        }
    },
    "certificateAuthorities": {
        "ca.org2.example.com": {
            "url": "http://HOST2_IP:8054",
            "caName": "ca.org2.example.com"
        }
    }
}
EOF

PRIVATE_KEY="${DIR}"/composer/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/"${ORG2KEY}"
CERT="${DIR}"/composer/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/Admin@org2.example.com-cert.pem

if composer card list -c PeerAdmin@pocnet1-org2-only > /dev/null; then
    composer card delete -c PeerAdmin@pocnet1-org2-only
fi

if composer card list -c PeerAdmin@pocnet1-org2 > /dev/null; then
    composer card delete -c PeerAdmin@pocnet1-org2
fi

composer card create -p edexaorg2onlyconnection.json -u PeerAdmin -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file /tmp/PeerAdmin@pocnet1-org2-only.card
composer card import --file /tmp/PeerAdmin@pocnet1-org2-only.card

composer card create -p edexaorg2connection.json -u PeerAdmin -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file /tmp/PeerAdmin@pocnet1-org2.card
composer card import --file /tmp/PeerAdmin@pocnet1-org2.card

#rm -rf org2onlyconnection.json

echo "Hyperledger Composer PeerAdmin card has been imported"
composer card list
echo "#############"
