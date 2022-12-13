#!/bin/bash
# author: eleAche
# description: this script does a global recognition from a web domain
set -e # strict mode

DOMAIN=$1
OUTPUT=scanningfor-${DOMAIN%.com}.txt
SCAN=$(mktemp)

verify() {
  local dependencie="$1"
  command -V $dependencie 1>/dev/null || ( echo "please install $dependencie" )
}

get_subdomains() {
  local domain="$1"
  subfinder -d $domain
}

scanning() {
  local domain="$1"
  get_subdomains "$domain" | xargs whatweb >> $SCAN
}

get_hosts() {
  grep -Eo '[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}' "$SCAN" | sort -u | uniq
}

gathering_ports() {
  local host=$1
  proxychains4 nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn "$host"
}

vortice() {
cat << 'EOF' > /tmp/proxychains4.conf
# proxychains4.conf
strict_chain
round_robin
chain_len=1
proxy_dns
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
proxy_dns 
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks4	127.0.0.1 9050
socks4	127.0.0.1 9051
EOF
  pgrep tor | xargs sudo kill
  sudo cp /tmp/proxychains4.conf /etc/proxychains4.conf >/dev/null
}

# requirements
verify nmap
verify proxychains4
verify tor
verify whatweb
verify subfinder
[[ "$#" -eq 1 ]] || echo "only 1 argument!"
[[ "$UID" -eq "0" ]] || echo "require root"

# main
vortice
tor >/dev/null &
scanning "$DOMAIN" 2>>$SCAN

for target in `get_hosts`
  do
    gathering_ports "$target" >> $OUTPUT
    let c++
    echo -en "\e[3${RANDOM::1}m [$c] scanning ${target}... \e[m\r"
  done
