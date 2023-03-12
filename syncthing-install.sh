wget https://github.com/syncthing/syncthing/releases/download/v1.23.2/syncthing-linux-arm64-v1.23.2.tar.gz

tar -xvf syncthing-*.tar.gz
mv syncthing-*/ syncthing/
./syncthing/syncthing &
sleep 10
pkill syncthing

sed -i "s|127.0.0.1:8384|0.0.0.0:8384|i" ~/.config/syncthing/config.xml

sudo firewall-cmd --zone=public --permanent --add-port=8384/tcp
sudo firewall-cmd --reload

nohup ./syncthing/syncthing 2>&1 &
