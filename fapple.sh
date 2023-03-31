#!/bin/bash
# entorno: parrot Live Cybersecurity
set -e # set strict mode for security
instalador_debian(){
sudo apt install -y libimobiledevice6 libimobiledevice-utils
wget -O - https://assets.checkra.in/debian/archive.key | gpg --dearmor | sudo tee /usr/share/keyrings/checkra1n.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/checkra1n.gpg] https://assets.checkra.in/debian /' | sudo tee /etc/apt/sources.list.d/checkra1n.list
sudo apt-get update
sudo apt-get install checkra1n
}

instalar_exploit(){
    sudo checkra1n
}

exploit(){
    bash iproxy 2022:44 &
    echo "ROOT PASS: alpine   ;}"
    ssh root@localhost -p 2022
}


ayuda(){
cat << 'EOF'
Atencion: un ejemplo de uso de esta utilidad, es el desbloqueo del dispositivo

-----------------
mount -o rw,union,update /
echo "" >> /.mount_rw
mv /Applications/Setup.app/Setup /Applications/Setup.ap/Setup.bak
uicache -a


mount -o rw,union,update /
rm -rf /Applications/Setup.app
uicache -p /Applications/Setup.app
killall backboardd
-----------------
pass: alpine
EOF
}

main(){
    # requirements
    instalador_debian

# menu
cat << 'INICIO'
       Elige alguna de las siguientes opciones
        [1] mostrar ayuda
        [2] instalar exploit
        [3] ejecutar exploit (similar a msfvenom/meterpreter de metasploit)
        [4] salir
INICIO

# controlador de opciones
while :
  do
    read -p "    opcion: " OPCION
  case $OPCION in 
        1)
        ayuda ;;
        2)
        instalar_exploit && break ;;
        3)
        exploit && break ;;
        4)
        return 0 ;;
        *)
        echo "opcion invalida!!" ;;
    esac
done
}

main