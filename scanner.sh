#!/bin/bash
# nmap_diy - simple CLI

while true; do
    echo
    echo "=== nmap_diy ==="
    echo "1) Vérifier si une cible est accessible (ping)"
    echo "2) Trouver les machines actives d'un réseau local"
    echo "q) Quitter"
    read -p "Choix: " choice

    case "$choice" in
        1)
            read -p "Entrez une adresse IP : " ip
            echo "ip testée : $ip"

            if ping -c 1 -W 1 $ip > /dev/null 2>&1; then
                echo "$ip addresse IP accessible"
            fi
            ;;
        2)
            read -p "Entrez une plage d'adresses IP (ex:192.168.1.1/24) : " subnet
            echo "Scan en cours pour le réseau $subnet..."
            ip=$(echo "$subnet" | cut -d'/' -f1)
            mask=$(echo "$subnet" | cut -d'/' -f2)

            base_ip=$(echo "$ip" | cut -d'.' -f1-3)
            for i in $(seq 1 254); do 
                if ping -c 1 -W 1 $base_ip.$i > /dev/null 2>&1; then
                    echo "$base_ip.$i addresse IP accessible"
                fi
            done
            ;;
        q|Q)
            echo "Au revoir."
            exit 0
            ;;
        *)
            echo "Choix invalide. Réessayez."
            ;;
    esac
done

