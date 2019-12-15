#!/bin/bash

#dependencies:
#it works on systems that use network-manage such as Ubuntu and Debian
#wget and ping (but can be modified to use only one )

CONNECTION_CHECK_REFRESH_PERIOD=10
NMCLI_CONNECTION_NAME="connection1" #use "nmcli connection" command to see the connection name
URL_TO_BE_CHECKED="http://google.com"


function reactivate_network(){
	nmcli con up $NMCLI_CONNECTION_NAME
}

function check_network_wget(){
	echo "checking internet with wget:"
	wget -q --spider $URL_TO_BE_CHECKED

	if [ $? -eq 0 ]; then
	    echo "Online"
	else
	    echo "Offline"
		reactivate_network
		check_network_ping
	fi
	}

function check_network_ping(){
	echo "checking internet with ping:"
	wget -q --spider $URL_TO_BE_CHECKED

	if [ $? -eq 0 ]; then
	    echo "Online"
	else
	    echo "Offline, trying to reactivate"
		reactivate_network
		check_network_wget
	fi
	}

function main(){
	while true
	do 
		check_network_wget
		sleep $CONNECTION_CHECK_REFRESH_PERIOD
	done
}

main
