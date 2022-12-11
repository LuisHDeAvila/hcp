#!/bin/bash
SCAN=$(mktemp)
verify(){
  local dependencie="$1"
  command -V $dependencie 1>/dev/null || ( echo "please install $dependencie" 
}
verify nmap
verify proxychains
verify tor
verify whatweb
verify subfinder

get_subdomains(){
  local domain="$1"
  subfinder -d $domain
}

scanning(){
  local domain="$1"
  get_subdomains "$domain" | xargs whatweb >> $SCAN
}

get_hosts(){
  grep -Eo '[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}' "$SCAN"
}

gathering_ports(){
  local host=$1
  proxychains nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn "$host"
}

[[ "$UID" -eq "0" ]] || echo "require root" && exit

read -p "Confirmar ejecucion [please press enter or ctrl+c]"
scanning "$1"
for TARGET in `get_hosts`
  do
    gathering_ports "$TARGET"
  done
