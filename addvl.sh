#!/bin/bash
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/v2ray/domain)
else
domain=$IP
fi
if [[ "$IPHost" = "" ]]; then
PUBLIC_IP=$(wget -qO- http://ipecho.net/plain | xargs echo);
else
PUBLIC_IP=$IPHost
fi
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo "Checking Vps"
curl -o.html https://icanhazip.com
sleep 0.5
clear
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/v2ray/vless.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#tls$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/v2ray/vless.json
sed -i '/#none$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/v2ray/vnone.json
vlesslink1="vless://${user}@${domain}:2083?path=/v2ray&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${user}@${domain}:8880?path=/v2ray&encryption=none&type=ws#${user}"
systemctl restart v2ray@vless
systemctl restart v2ray@vnone
clear
echo -e ""
echo -e "==========-V2RAY/VLESS-=========="
echo -e "Remarks        : ${user}"
echo -e "Domain         : ${domain}"
echo -e "Server IP      : $PUBLIC_IP"
echo -e "port TLS       : 2083"
echo -e "port none TLS  : 8880"
echo -e "id             : ${user}"
echo -e "Encryption     : none"
echo -e "network        : ws"
echo -e "path           : /v2ray"
echo -e "================================="
echo -e "link TLS       : ${vlesslink1}"
echo -e "================================="
echo -e "link none TLS  : ${vlesslink2}"
echo -e "================================="
echo -e "Expired On     : $exp"
echo -e "By ME"
