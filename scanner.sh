#!/bin/bash
# nmap_diy 

echo "Entrez un adresse ip : " 
read ip 
echo "ip testée : $ip"
ping -c 1 -W 1 $ip > /dev/null

if [ $? -eq 0 ]; then  
    echo "Cible $ip est en accessible"
else 
    echo "Cible $ip est inaccessbile"
fi
