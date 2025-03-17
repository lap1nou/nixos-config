if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: htb-new [arguments]"
    echo
    echo "Create a new Exegol container for a specific HTB machine."
    echo
    echo "Arguments:"
    echo "  --help,-h    Show this help message and exit."
    echo "  HTB machine name      The name of the HTB machine."
    echo "  Machine IP      The IP of the HTB machine."
    exit 0
fi

exegol start "$1" full -l --comment "Exegol container for the machine "$1"" --disable-shared-network --vpn ~/lab_lap1nou.ovpn --env HTB=1 --env HTB_NAME_TMP=$1 --env DOMAIN_TMP=$1.htb --env TARGET_TMP=$2 