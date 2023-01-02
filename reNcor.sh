#!/bin/bash
# author: eleAche
# description: this script does a global recognition from a web domain
set -e # strict mode

# first parameter
DOMAIN=$1
REPORT_FILE="With_reNcor.txt"
OUTPUT=scanningfor-${DOMAIN%.com}.txt
SCAN=$(mktemp)

# only is output function
look_this(){
  local log="$@"
  echo -en "[!] Scanning ==>> \e[3${RANDOM::1}m ${log} \e[m\r"
}

# check dependencies
verify() {
  local dependencie="$1"
  until command -V $dependencie 1>/dev/null; do
    echo "please install $dependencie"
  done
}

# find subdomains of any domain
get_subdomains() {
  local domain="$1"
  subfinder -d $domain
}

# xargs whatweb get the ip from domain
scanning() {
  local domain="$1"
  look_this "${domain}"
  get_subdomains "$domain" | xargs whatweb >> $SCAN
}

# ipv4 regex match
get_hosts() {
  grep -Eo '[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}\.[0-9]{,3}' "$SCAN" | sort -u | uniq
}

# scanning host
gathering_ports() {
  local host=$1
  proxychains4 nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn "$host"
}

# proxychains4 config file
kamui() {
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
  pgrep tor | xargs sudo kill || echo "[ok!]"
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
kamui
tor >/dev/null &
while :
  do
    if proxychains4 ping -c 1 $DOMAIN
      then
        break
    fi
    sleep 1s
done >/dev/null

echo " ... lets go!"
scanning "$DOMAIN" 2>>$SCAN

for target in `get_hosts`
  do
    gathering_ports "$target" >> $OUTPUT
    let c++
    echo -en "\e[3${RANDOM::1}m [$c] scanning ${target}... \e[m\r"
  done

cp "$OUTPUT" $REPORT_FILE
cat $REPORT_FILE
