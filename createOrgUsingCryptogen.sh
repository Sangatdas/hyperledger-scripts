#!/bin/bash
#================================================================
#	HELPER
#================================================================
function help() {
	echo SYNOPSIS
	echo    ${SCRIPT_NAME} [-hv] [-o[file]] args ...
	echo
	echo DESCRIPTION
	echo    This is a script template
	echo    to start any good shell script.
	echo
	echo OPTIONS
	echo    -o [file], --output=[file]    Set log file (default=/dev/null)
	echo                                  use DEFAULT keyword to autoname file
	echo                                  The default value is /dev/null.
	echo    -t, --timelog                 Add timestamp to log ("+%y/%m/%d@%H:%M:%S")
	echo    -x, --ignorelock              Ignore if lock file exists
	echo    -h, --help                    Print this help
	echo    -v, --version                 Print script information
	echo
	echo EXAMPLES
	echo    ${SCRIPT_NAME} -o DEFAULT arg1 arg2
	echo
#================================================================
	echo IMPLEMENTATION
	echo    version         ${SCRIPT_NAME} (www.uxora.com) 0.0.4
	echo    author          Michel VONGVILAY
	echo    copyright       Copyright (c) http://www.uxora.com
	echo    license         GNU General Public License
	echo    script_id       12345
	echo
#================================================================
	echo HISTORY
	echo    2015/03/01 : mvongvilay : Script creation
	echo    2015/04/01 : mvongvilay : Add long options and improvements
	echo
#================================================================
	echo DEBUG OPTION
	echo   set -n  	echoUncomment to check your syntax, without execution.
	echo   set -x  	echoUncomment to debug this shell script

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
	echo "############ Create Org1 Identities ######################"
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
