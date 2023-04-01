#!/bin/bash
# entorno: parrot Live Cybersecurity
set -e # set strict mode for security

instalador_debian(){
    [[ -e /tmp/.fapple ]] && break
apt-cache search usbmux | awk '{print $1}' | while read l; do sudo apt install -y "$l" ;done
apt-cache search libimobile | awk '{print $1}' | while read l; do sudo apt install -y "$l" ;done
wget -O - https://assets.checkra.in/debian/archive.key | gpg --dearmor | sudo tee /usr/share/keyrings/checkra1n.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/checkra1n.gpg] https://assets.checkra.in/debian /' | sudo tee /etc/apt/sources.list.d/checkra1n.list
sudo apt-get update -y
sudo apt-get install -y checkra1n
echo 'true' > /tmp/.fapple
clear
}

instalar_exploit(){
    sudo checkra1n
}

exploit(){
    bash iproxy 2022:44 &
    echo -e "\e[1;3${RANDOM};40mPASS: alpine   ;} \e[m\n"
    ssh root@localhost -p 2022
}


ayuda(){
    clear
cat << 'EOF'
Atencion: un ejemplo de uso de esta utilidad, es hacer jailbreak en IOS.
Herramientas como ifuse permiten acceder al sistema de archivos del usuario "mobile".
Con esta herramienta, puedes acceder como superusuario, ya que internamente IOs
lleva el nombre de Darwin, y hereda muchas caracteristicas de BSD, como el FHS (filesystem hierarchy standart)
El lenguaje de programacion que usa internamente se llama Objetive C, es muy parecido
a el lenguaje de programacion C.

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
    Esta herramienta se comparte con fines meramente educativos, 
    no me hago responsable del mal uso que se pueda hacer de la 
    misma, o de este conocimiento. 
    atte. eleAche
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