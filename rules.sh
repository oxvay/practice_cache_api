# PROXY - 192.168.8.124
sudo firewall-cmd --reset-to-defaults

# Разрешить все входящие соединения

sudo firewall-cmd --permanent --new-policy=allow-in
sudo firewall-cmd --permanent --policy=allow-in --add-ingress-zone=ANY
sudo firewall-cmd --permanent --policy=allow-in --add-egress-zone=HOST
sudo firewall-cmd --permanent --policy=allow-in --set-priority=-200
sudo firewall-cmd --permanent --policy=allow-in --set-target=ACCEPT

# Запретить все исходящие, кроме указанных IP

sudo firewall-cmd --permanent --new-policy=restrict-out
sudo firewall-cmd --permanent --policy=restrict-out --add-ingress-zone=HOST
sudo firewall-cmd --permanent --policy=restrict-out --add-egress-zone=ANY
sudo firewall-cmd --permanent --policy=restrict-out --set-priority=-100

# Разрешить исходящие подключения к Backend
sudo firewall-cmd --permanent --policy=restrict-out --add-rich-rule='rule family="ipv4" destination address="192.168.8.115" accept'

# Разрешить исходящие подключения к Redis
sudo firewall-cmd --permanent --policy=restrict-out --add-rich-rule='rule family="ipv4" destination address="192.168.8.123" accept'

# Все остальные исходящие подключения запретить
sudo firewall-cmd --permanent --policy=restrict-out --set-target=DROP

# Применить правила

sudo firewall-cmd --check-config
sudo firewall-cmd --reload

# BACKEND - 192.168.8.115
sudo ufw --force reset
sudo ufw default deny incoming # Запретить подключение от всех
sudo ufw default deny outgoing # Запретить исходящие ко всем
sudo ufw allow in from 192.168.8.124 # Разрешить входящее от Proxy
sudo ufw allow out to 192.168.8.114 # Разрешить исходящее к PostgreSQL
sudo ufw allow 22/tcp # Разрешить порт SSH
sudo ufw --force enable 

# POSTGRESQL - 192.168.8.114
sudo ufw --force reset
sudo ufw default deny incoming # Запретить подключение от всех
sudo ufw default deny outgoing # Запретить исходящие ко всем
sudo ufw allow in from 192.168.8.115 # Разрешить все от Backend
sudo ufw allow 22/tcp # Разрешить порт SSH
sudo ufw --force enable

# REDIS - 192.168.8.123
sudo ufw --force reset
sudo ufw default deny incoming # Запретить подключение от всех
sudo ufw default deny outgoing # Запретить исходящие ко всем
sudo ufw allow in from 192.168.8.124 # Разрешить подключения от Proxy
sudo ufw allow 22/tcp # Разрешить порт SSH
sudo ufw --force enable