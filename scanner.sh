#!/bin/bash
# nmap_diy - simple CLI

ip_to_int() {
    local IFS=.
    read -r i1 i2 i3 i4 <<< "$1"
    echo $((i1 * 256 ** 3 + i2 * 256 ** 2 + i3 * 256 + i4))
}

int_to_ip() {
    local ip_int=$1
    echo "$((ip_int / 256 ** 3 % 256)).$((ip_int / 256 ** 2 % 256)).$((ip_int / 256 % 256)).$((ip_int % 256))"
}

cidr_to_range(){
    local max_jobs=50
    local cidr=$1
    local ip="${cidr%/*}"
    local prefix="${cidr#*/}"
    if [[ $prefix -lt 0 || $prefix -gt 32 ]]; then
        echo "CIDR invalide"
        return
    fi
    local ip_int=$(ip_to_int "$ip")
    local mask
    let "mask = (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF"   
    local network=$(( ip_int & mask ))
    local broadcast=$(( network | (~mask & 0xFFFFFFFF) ))    
    echo "IP de départ : $ip"
    echo "IP en entier : $ip_int"
    echo "Masque : $mask"
    echo "Network : $network"
    echo "Broadcast : $broadcast"
    local total_hosts=$(( broadcast - network - 1 ))
    if (( total_hosts <= 0 )); then
        echo "Aucun hôte à scanner"
        return
    fi
    local count=0
    for ((i=network+1; i<broadcast; i++)); do
        local current_ip=$(int_to_ip "$i")
        count=$((count+1))
        printf "\rExplorées : %d / %d" "$count" "$total_hosts"
        ( # ajout parallelisation
        if ping -c 1 -W 1 "$current_ip" > /dev/null 2>&1; then
            printf "\n%s UP\n" "$current_ip"
        fi
        ) & 
        if (( $(jobs -r | wc -l) >= max_jobs )); then
            wait -n
        fi

    done
    printf "\nScan terminé : %d hôtes explorés\n" "$count"
    
}
while true; do
    echo
    echo "=== nmap_diy ==="
    echo "1) Vérifier si une cible est accessible (ping)"
    echo "2) Trouver les machines actives d'un réseau local"
    echo "3) Scanner les ports d'une machine"
    echo "q) Quitter"
    read -p "Choix: " choice

    case "$choice" in
        1)
            read -p "Entrez une adresse IP : " ip
            echo "ip testée : $ip"

            if ping -c 1 -W 1 "$ip" > /dev/null 2>&1; then
                echo "$ip adresse IP accessible"
            else
                echo "$ip inaccessible"
            fi
            ;;
        2)
            read -p "Entrez une plage d'adresses IP (ex:192.168.1.1/24) : " subnet
            echo "Scan en cours pour le réseau $subnet..."

            cidr_to_range "$subnet"
            ;;
        3)
            read -p "Entrez une adresse IP : " ip
            echo "Scan des ports pour $ip..."
            
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

