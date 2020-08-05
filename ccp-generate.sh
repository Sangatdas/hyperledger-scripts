#!/bin/bash
#================================================================
#	HELPER
#================================================================
VERSION="0.0.1"
function printHelp() {
	echo "SYNOPSIS"
	echo    "createOrgUsingCryptogen [[-option] arg] ..."
	echo
	echo "DESCRIPTION"
	echo    "This is a script to create an organisation for"
	echo    "Hyperledger Fabric Test Network"
	echo
	echo "OPTIONS"
	echo    "--domain [value]	Set value of domain for peer of organisation (Must match docker compose file)"
	echo	"--name [value]	Set value of name for organisation (Must match crypto config file)"
	echo	"--pname [value]	Set value of peer name of organisation (Must match docker compose file)"
	echo	"--peerpem [file]	Set path to peer .pem file for organisation (Generated from cryptogen)"
	echo	"--capem [file]	Set path to ca .pem file for organisation (Generated from cryptogen)"
	echo	"--peerport [value]	Set value of peer port for organisation (Must match docker compose file)"
	echo	"--caport [value]	Set value of CA port for organisation"
	echo    "-h, --help            Print this help"
	echo    "-v, --version         Print script version"
	echo
	echo "EXAMPLES"
	echo    "ccp-generate.sh --domain peer0.org1.example.com --name Org1 --pname peer0 --peerpem ../organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem --capem ../organizations/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem --peerport 7051 --caport 7054"
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
function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $6)
    local CP=$(one_line_pem $7)
    sed -e "s/\${ORG_NAME}/$1/" \
        -e "s/\${PEER_NAME}/$2/" \
        -e "s/\${ORG_DOMAIN}/$3/" \
        -e "s/\${PEER_PORT}/$4/" \
        -e "s/\${CA_PORT}/$5/" \
        -e "s#\${PEERPEM_PATH}#$PP#" \
        -e "s#\${CAPEM_PATH}#$CP#" \
        ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $6)
    local CP=$(one_line_pem $7)
    sed -e "s/\${ORG_NAME}/$1/" \
        -e "s/\${PEER_NAME}/$2/" \
        -e "s/\${ORG_DOMAIN}/$3/" \
        -e "s/\${PEER_PORT}/$4/" \
        -e "s/\${CA_PORT}/$5/" \
        -e "s#\${PEERPEM_PATH}#$PP#" \
        -e "s#\${CAPEM_PATH}#$CP#" \
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
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
  --domain )
    ORG_DOMAIN="$2"
    shift
    ;;
  --name )
    ORG_NAME="$2"
    shift
    ;;
  --pname )
    PEER_NAME="$2"
    shift
    ;;    
  --peerpem )
    PEERPEM_PATH="$2"
    shift
    ;;   
  --capem )
    CAPEM_PATH="$2"
    shift
    ;;
  --peerport )
    PEER_PORT="$2"
    shift
    ;;
  --caport )
    CA_PORT="$2"
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

echo "##############################################################"
echo "################## Details Captured ##########################"
echo "##############################################################"
echo "ORG_NAME: $ORG_NAME"
echo "PEER_NAME: $PEER_NAME"
echo "ORG_DOMAIN: $ORG_DOMAIN"
echo "PEER_PORT: $PEER_PORT"
echo "CA_PORT: $CA_PORT"
echo "PEERPEM_PATH: $PEERPEM_PATH"
echo "CAPEM_PATH: $CAPEM_PATH" 

echo "$(json_ccp $ORG_NAME $PEER_NAME $ORG_DOMAIN $PEER_PORT $CA_PORT $PEERPEM_PATH $CAPEM_PATH)" > ../organizations/peerOrganizations/$ORG_DOMAIN/connection-$ORG_NAME.json
echo "$(yaml_ccp $ORG_NAME $PEER_NAME $ORG_DOMAIN $PEER_PORT $CA_PORT $PEERPEM_PATH $CAPEM_PATH)" > ../organizations/peerOrganizations/$ORG_DOMAIN/connection-$ORG_NAME.yaml





