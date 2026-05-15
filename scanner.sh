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
            if ping -c 1 -W 1 "$ip" > /dev/null 2>&1; then
                echo "Cible $ip est accessible"
            else
                echo "Cible $ip est inaccessible"
            fi
            ;;
        2)
            echo "Option 2: Trouver les machines actives d'un réseau local"
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

