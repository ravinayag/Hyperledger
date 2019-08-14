# Hyperledger Fabric v1.4.1 + Composer  version 20.8 + Explorer 3.9 + MultiHost +  MultiOrg + Multipeer + Multichannel
Part of a PoC to explore blockchain solutions. I choosed Hyperledger a open source community. Hyperledger Fabric  and Hyperledger composer has used for this projec.

#### Network Setup:
The network will contain two  Nodes ( Hosts) Node 00 and Node01  and mapped to  Org1 & Org2 respectively.

Host1 : Orderer, CA0, Org1- Peer0, peer1, peer2
Host2 : CA1, Org2- Peer0,  peer1, peer2

we will have 1 Orderer and 2 CA’s  as recommended and best practice followed  that each Org should have its own CA and multiple orderers to avoid a single point of failure. ( We will add orderers,Orgs, Peers separately to exsisting setup)

![Mynetwork Image](http://my.img)



#### Prerequisites: 
* Phy/Virtual Machine : Running Ubuntu OS 16.4 LTS
* Env setup : curl, Docker, Docker-compose, Go, Hyperledger binaries, Nodejs, composer, [Ref](https://hyperledger-fabric.readthedocs.io/en/release-1.4/getting_started.html)
* Follow the instructions for all two nodes  and do reboot. Ensure docker services is running.

Once you ready with your network  and  prerequisites. 
Note : I created script [Prereq_HLFv11.sh](https://github.com/ravinayag/Hyperledger/blob/master/prereqs_hlfv14.sh)

Down the hyperledger  binaries.
Ref : https://hyperledger-fabric.readthedocs.io/en/release-1.4/install.html
```bash
curl -sSL http://bit.ly/2ysbOFE | bash -s 
```

Here you will see download_hlf.sh, and execute to 
[download_hlf.sh](https://github.com/ravinayag/Hyperledger/blob/master/download_hlf.sh)
```bash
$ ./download_hlf.sh
```

Once the docker images are set,  now move to composer folder and generate articrafts.
Replace the IP addresses in NODE01 and NODE02 with  your own IPs and Run the script
```bash
$cd myhlf_compser && vi generate.sh
$start2fabric_org1.sh
```
At this point, your first node is ready in the network, if you have done these instructions for Node00 machine, then we need to copy  same to second node, Doing this will ease our work.  Move back to parent folder :

```bash
$cd ~ 
$tar cf myhlf_compser.tar ./myhlf_compser/ 

Login to node01 :
$scp user@node00:/path_to_the_tar file .
```
extract the tar file and change directory to scripts
```bash $cd myhlf_compser ```
Now run the run ```bash $./start2fabric_org2.sh ```


##### This will fetch the keys and join the Peer nodes. Now your Fabric is ready 

## Hyperledger Composer Setup

Now move back to first  node node00 for composer install
#### Prerequisites: 
1. npm version 6.2.0 
2. node version 8.9.1 
3. composer-cli version v0.20 
4. composer-rest-server version 0.20 
5. generator-hyperledger-composer version 0.20 
6. yo version 2.05

```bash
$npm install -g yo composer-cli@0.20 composer-playground@0.20 generator-hyperledger-composer@0.20 composer-connector-server@0.20 composer-rest-server@0.20
```

Note : composer and fabric are mostly bended with version dependency. Hence need to carefull before deployment. 
Ensure you have the given version., Now you ready to create admincard for sample testing, Run the script. 

```bash
$./createPeerAdminCard.sh

$ composer network ping –c peeradmin@sample-network 
```
You will get ping response as below screen shoot

#### Now we are ready to access the network through composer

Run this command on your terminal and open the browser to access your network.

```bash
$ composer-playground -p 8181 &

on Browser
http://server_IP:8181 

```
You Can Play around now. 


## Lets start REST services for the  same network.

Hyperledger Composer includes a standalone Node.js process that exposes a business network as a REST API. 
The LoopBack framework is used to generate an Open API, described by a Swagger document.

To launch the REST Server simply type:
```bash
$composer-rest-server
```
You will then be asked to enter a few simple details about your business network. An example of consuming a deployed business network is shown below.
```bash
? Enter the name of the business network card to use: alice@sample-network
? Specify if you want namespaces in the generated REST API: always use namespaces  
? Specify if you want to enable authentication for the REST API using Passport: No 
? Specify if you want to enable event publication over WebSockets: Yes             
? Specify if you want to enable TLS security for the REST API: No

To restart the REST server using the same options, issue the following command:
   
   composer-rest-server -c alice@sample-network -n always -w true
   
   Discovering types from business network definition ...                    
   Discovered types from business network definition                          
   Generating schemas for all types in business network definition ...         
   Generated schemas for all types in business network definition                 
   Adding schemas for all types to Loopback ...                                    
   Added schemas for all types to Loopback                                          
   

  Web server listening at: http://localhost:3000

  Browse your REST API at http://localhost:3000/explorer
```
