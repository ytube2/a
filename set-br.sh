#!/bin/bash
curl https://rclone.org/install.sh | bash
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/sfeduku/sco/main/rclone.conf"
apt install msmtp-mta ca-certificates bsd-mailx -y
cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user syngml343@gmail.com
from syngml343@gmail.com
password dhemorche
logfile ~/.msmtp.log
EOF
chown -R www-data:www-data /etc/msmtprc
cd /usr/bin
wget -O autobackup "https://raw.githubusercontent.com/sfeduku/sco/main/autobackup.sh"
wget -O backup "https://raw.githubusercontent.com/sfeduku/sco/main/backup.sh"
wget -O bckp "https://raw.githubusercontent.com/sfeduku/sco/main/bckp.sh"
wget -O restore "https://raw.githubusercontent.com/sfeduku/sco/main/restore.sh"
wget -O strt "https://raw.githubusercontent.com/sfeduku/sco/main/strt.sh"
chmod +x autobackup
chmod +x backup
chmod +x bckp
chmod +x restore
chmod +x strt
cd
rm -f /root/set-br.sh
