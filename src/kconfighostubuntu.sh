sudo useradd kalanhost
sudo usermod -aG docker kalanhost
sudo usermod -aG admin kalanhost
sudo usermod -aG sudo kalanhost
mkhomedir_helper kalanhost

sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
sudo chmod a-w /etc/ssh/sshd_config.factory-defaults
sudo sh -c "echo 'AllowUsers root kalanhost' >> /etc/ssh/sshd_config"
sudo ufw limit ssh
