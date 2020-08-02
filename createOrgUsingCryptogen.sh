#!/bin/bash
#================================================================
#	HELPER
#================================================================
VERSION="0.0.1"
CRYPTO_CFG_PATH_FOR_ORG=""
COMPOSE_FILE_FOR_ORG=""
function printHelp() {
	echo "SYNOPSIS"
	echo    "createOrgUsingCryptogen [[-option] arg] ..."
	echo
	echo "DESCRIPTION"
	echo    "This is a script to create an organisation for"
	echo    "Hyperledger Fabric Test Network"
	echo
	echo "OPTIONS"
	echo    "-p [file]		Set path to crypto config yaml for organisation"
	echo	"-d [file]		Set path to docker compose file for organisation"
	echo    "-h, --help            Print this help"
	echo    "-v, --version          Print script version"
	echo
	echo "EXAMPLES"
	echo    "createOrgUsingCryptogen -p crypto-config-org1.yaml -d docker-compose-test.yaml"
	echo
	echo
#================================================================
	echo "IMPLEMENTATION"
	echo    "version        createOrgUsingCryptogen (https://github.com/Sangatdas/hyperledger-scripts) 0.0.1"
	echo    "author         Sangat Das"
	echo 	"date 		2nd August 2020"
	echo
	echo
#================================================================
	echo "HISTORY"
	echo    "02/08/2020 : Sangatdas : Script creation"
	echo    
#================================================================

}
#================================================================
#	END_OF_HELPER
#================================================================

function generateCryptoUsingCryptogenTool() {
	which cryptogen
	if [ "$?" -ne 0 ]; then
		echo "cryptogen tool not found. exiting"
		exit 1
	fi

	echo
	echo "##########################################################"
	echo "##### Generate certificates using cryptogen tool #########"
	echo "##########################################################"
	echo

	echo "##########################################################"
	echo "############ Create Org Identities ######################"
	echo "##########################################################"

	set -x
	cryptogen generate --config=$CRYPTO_CFG_PATH_FOR_ORG --output="organizations"
	res=$?
	set +x

	if [ $res -ne 0 ]; then
		echo $'\e[1;32m'"Failed to generate certificates..."$'\e[0m'
		exit 1
	fi

}

function createContainerForOrg() {
	echo "################################################################"
	echo "###### Generate container for peer using docker compose ########"
	echo "################################################################"
	set -x
	docker-compose -f $COMPOSE_FILE_FOR_ORG up -d
	res=$?
	set +x
	
	docker ps -a
	
	if [ $res -ne 0 ]; then
		echo $'\e[1;32m'"Failed to create container...."$'\e[0m'
		exit 1
	fi
	
}

if [[ $# -lt 1 ]] ; then
  printHelp
  exit 0
fi

while [[ $# -ge 1 ]] ; do
  key="$1"
  case $key in
  -h )
    printHelp
    exit 0
    ;;
  --help )
    printHelp
    exit 0
    ;;
  -p )
    CRYPTO_CFG_PATH_FOR_ORG="$2"
    shift
    ;;
  -d )
    COMPOSE_FILE_FOR_ORG="$2"
    shift
    ;;
  -v )
    echo $VERSION
    exit 0
    ;;
  --version )
    echo $VERSION
    exit 0
    ;;
  * )
    echo
    echo "Unknown flag: $key"
    echo
    printHelp
    exit 1
    ;;
  esac
  shift
done

if [ "$CRYPTO_CFG_PATH_FOR_ORG" == "" ]; then
	echo "Crypto Config file (YAML) for organisation not provided in arguments. Please refer help."
	printHelp
	exit 1
fi

if [ "$COMPOSE_FILE_FOR_ORG" == "" ]; then
	echo "Docker COmpose file for organisation not provided in arguments. Please refer help."
	printHelp
	exit 1
fi

generateCryptoUsingCryptogenTool
createContainerForOrg

