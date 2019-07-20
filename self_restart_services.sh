#!/bin/sh
export cservice=composer

if [ `ps -ef | grep -v grep | grep $cservice | grep 3000 | wc -l` -ne 0 ]
then
	echo " $cservice at port 3000 is already running!!!"
else
	nohup composer-rest-server -c alice@trade-network -n never -u true -w true -p 3000 & 
fi

if  [ `ps -ef | grep -v grep | grep $cservice | grep 3002 | wc -l` -ne 0 ]
then
	echo " $cservice at port 3002 is already running!!!"
else
	nohup composer-rest-server -c alice@trade-storage -n never -u true -w true -p 3002 & 
fi

if [ `ps -ef | grep -v grep | grep $cservice | grep 3004 | wc -l` -ne 0 ]
then
	echo " $cservice at port 3004 is already running!!! "
else
	nohup composer-rest-server -c alice@trade-signature -n never -u true -w true -p 3004 & 
fi

#if (( $(ps -ef | grep -v grep | grep $cservice | wc -l > 0 ))

if [ `ps -ef | grep -v grep | grep $cservice | grep 8181 | wc -l` -ne 0 ]
then
	echo " $cservice at port 8181 is already running!!!"
else
	nohup composer-playground -p 8181 &
fi
