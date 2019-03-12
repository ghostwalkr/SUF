
# SSH Username Finder v1.4
SSH User Finder is a script to enumerate SSH usernames by exploiting CVE-2018-15473. It only works on OpenSSH versions less than 7.7. Link to exploit code: https://www.exploit-db.com/exploits/45939 
### Dependencies: 
python, 
python-argparse, 
python-logging, 
python-paramiko, 
python-socket, 
python-sys, 
python-os. 

### Installation and Usage
To use the script just clone the repository and execute.

1. git clone https://github.com/ghostwalkr/SUF.git
2. chmod -R 744 SUF
3. cd SUF
4. ./suf.sh for interactive 
Use -u and -i arguments for userfile and ipfile. For example ./suf.sh -u userfile.txt -i ipfile.txt
The order of the arguments is important.

![suf demo](https://media.giphy.com/media/1j9frMjJlzbrIpPnp1/giphy.gif)

### Contribute
If you want to contribute to this project one of the best things you can do is use it. Test it, find issues with it, think of features for it. I'd also appreciate feedback.
### TODO:
- Make "prettier" output?
