cd ~
git clone https://github.com/facebook/watchman.git
cd watchman/
git checkout v4.7.0
sudo apt-get install -y autoconf automake build-essential python-dev
./autogen.sh 
./configure 
make
sudo make install

watchman --version
echo 999999 | sudo tee -a /proc/sys/fs/inotify/max_user_watches  && echo 999999 | sudo tee -a  /proc/sys/fs/inotify/max_queued_events && echo 999999 | sudo tee  -a /proc/sys/fs/inotify/max_user_instances && watchman  shutdown-server
