#!/bin/bash
# author: eleAche
# description: this script does a global recognition from a web domain

SCAN=$(mktemp)
verify(){
  local dependencie="$1"
  command -V $dependencie 1>/dev/null || ( echo "please install $dependencie" )
}
verify nmap
verify proxychains4
verify tor
verify whatweb
verify subfinder

get_subdomains() {
  local domain="$1"
  subfinder -d $domain
}

scanning(){
  local domain="$1"
  get_subdomains "$domain" | xargs whatweb >> $SCAN
}

get_hosts(){
  grep -Eo '[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}' "$SCAN" | sort -u | uniq
}

gathering_ports(){
  local host=$1
  proxychains4 nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn "$host"
}

[[ "$#" -eq 1 ]] || echo "only 1 argument!"
[[ "$UID" -eq "0" ]] || echo "require root"

vortice() {
  pgrep tor | xargs sudo kill

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

  sudo cp /tmp/proxychains4.conf /etc/proxychains4.conf
}

# main
vortice
tor >/dev/null &
scanning "$1" 2>>$SCAN
for TARGET in `get_hosts`
  do
    gathering_ports "$TARGET" >> scanningfor-${1%.com}.txt
    let c++
    echo -en "\e[3${RANDOM::1}m [$c] scanning $TARGET... \e[m\r"
  done

