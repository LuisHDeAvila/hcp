#!/bin/bash
: '
	this script provides a timeline report to detect advanced persistent threats. About how get results: spanish: https://es.wikipedia.org/wiki/Inteligencia_de_se%C3%B1ales || english: https://en.wikipedia.org/wiki/Signals_intelligence

	Wireshark is an protocol analyzer, It supports more than 480 protocols. normally wireshark outputs have the extension .pcap/.pcapng
	Keras in Deep Learning as a well-known library in the world of neural networks. Its main features are that it is an open source library and it works with TensorFlow, which is why it is one of the most widely used in the analysis of deep neural networks.

	it occurred to me reading this: https://www.ccn-cert.cni.es/pdf/documentos-publicos/xi-jornadas-stic-ccn-cert/2602-m31-03-hacking-hackers/file.html

	is a core markov modulus.
'
# if you have files on extern disks, create subdirectories in /mnt and mount all disks
check_environment()
{
declare -a requirements=(tshark python "python-keras" exiftool curl)
for requirement in ${requirements[@]}
  do
  	until command -V $requirement >/dev/null
  	  do
  	  	echo "Please, install $requirement."
  	  	break
  	  done 2>/dev/null
  done
}

# look at `man hier` for criteria on which files to skip
exclude_paths=('\/usr\/share\/' '\/opt\/')

# parse wireshark outputs
get_data(){
  sudo find /home -iname '*.pcap' -or -iname '*.pcapng' | while read line
    do
  		echo "$line"
		sudo tshark -r "$line" -zio,phs
  done
}

# main
check_environment
get_data
