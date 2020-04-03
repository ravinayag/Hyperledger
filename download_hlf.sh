#!/bin/sh

#For latest version  
#curl -sSL   https://raw.githubusercontent.com/hyperledger/fabric/master/scripts/bootstrap.sh | bash -s
### Short link: uncomment this if have to do with short link
#curl -sSL http://bit.ly/2ysbOFE | bash -s
#chmod 777 -R fabric-samples


#### if you need to download specific version follow below syntax
#curl -sSL http://bit.ly/2ysbOFE | bash -s -- <fabric_version> <fabric-ca_version> <thirdparty_version>
curl -sSL http://bit.ly/2ysbOFE | bash -s -- 1.4.2 1.4.2 0.4.15
