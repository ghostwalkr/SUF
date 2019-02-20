SSH User Finder is a script to enumerate SSH usernames by exploiting CVE-2018-15473. It only works on OpenSSH versions less than 7.7.
Link to exploit code: https://www.exploit-db.com/exploits/45939
Dependencies: python, argparse, logging, paramiko, socket, sys, os.
To use the script just clone the repository and execute.
1. git clone https://github.com/ghostwalkr/SUF.git
2. chmod -R 744 SUF
3. cd SUF
4. ./suf.sh target userfile

Usage: suf.sh target userfile
