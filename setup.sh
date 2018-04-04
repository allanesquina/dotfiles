#/usr/bin/env bash
myecho() {
	#    .---------- constant part!
	#    vvvv vvvv-- the code from above
	YELLOW='\033[1;33m'
	RED='\033[0;31m'
	NC='\033[0m'
	CYAN='\033[00;36m'
	echo -e "${YELLOW}"
	echo -e "- ${1}"
	echo -e "${CYAN}"
}

sayok() {
	CYAN='\033[00;36m'
	GREEN='\033[1;32m'
	echo -e "${GREEN}"
	echo -e "-------------------------------------------OK"
	echo -e "${CYAN}"
}

curlSetup() {
	# CURL
	myecho "CURL"
	sudo apt install curl
	sayok
}

gitSetup() {
	# GIT
	myecho "GIT"
	sudo apt install git
	sayok

	myecho "GIT global config"
	git config --global user.name "Allan Esquina"
	git config --global user.email "loloudxur@gmail.com"
	sayok
}

setup() {
	# Local vars 
	DOTFILES=$HOME/dotfiles
	DOTREPO=https://github.com/allanesquina/dotfiles.git

	myecho "Updating"
	sudo apt-get update

	# Verify if dotfiles folder exists
	if [ "$DOTFILES" ]; then
		myecho "Dotfiles already downloaded"
		sayok
	else
		myecho "Downloading dotfiles from github into ${DOTFILES}"
		git clone $DOTREPO $DOTFILES 
		sayok
	fi

	# Start the menu
	applications
}

setupAll() {
	curlSetup
	gitSetup
	vimSetup
	agSetup
	xtermSetup
	tmuxSetup
	nodeSetup
	dockerSetup
	yarnSetup
	fontSetup
	keyboardSetup
}

keyboardSetup() {
	# Keyboard configuration
	myecho "Configuring Keyboard speed rate"
	xset r rate 185 70
	sayok
}

vimSetup() {
	# Vim instalation
	myecho "Vim"
	sudo apt install vim
	ln -sf $DOTFILES/vim/vimrc $HOME/.vimrc
	sayok
}

nodeSetup() {
	# Node Instalation
	myecho "NodeJS By NVM"
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
	nvm install 8
	sayok
}

tmuxSetup() {
	# Tmux instalation
	myecho "Tmux"
	sudo apt install tmux
	ln -sf $DOTFILES/tmux.conf $HOME/.tmux.conf
	sayok
}

xtermSetup() {
	# Xterm Config
	myecho "Xterm"
	sudo apt-get install xterm
	ln -sf $DOTFILES/Xresources.hybird $HOME/.Xdefaults
	xrdb .Xdefaults
	sayok
}

agSetup() {
	# Ag search
	myecho "Ag search"
	sudo apt-get install silversearcher-ag 
	sayok
}

dockerSetup() {
	myecho "Docker"
	sudo apt-get update
	sudo apt-get install \
	    apt-transport-https \
	    ca-certificates \
	    curl \
	    software-properties-common

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   $(lsb_release -cs) \
	   stable"
	sudo apt-get update
	sudo apt-get install docker-ce
	sudo docker run hello-world
	sayok
}

yarnSetup() {
	myecho "Yarn"
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -                                                                                                   
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list                                                                       
	sudo apt-get update                                                                                                                                                      
	sudo apt-get install --no-install-recommends yarn  
	sayok
}

fontSetup() {
	myecho "Fonts"
	sudo cp $DOTFILES/fonts/*.ttf /usr/share/fonts/TTF/
	sudo cp $DOTFILES/fonts/*.otf /usr/share/fonts/OTF/
	fc-cache
	sayok
}

watchmanSetup() {
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
}

applications() {
	options=(
		"curl"
		"git"
		"vim"
		"ag"
		"xterm"
		"tmux"
		"node"
		"docker"
		"yarn"
		"font"
		"keyboard"
		"watchman"
		"Install All"
	)

	echo -e "Choose your application to install"
	select opt in "${options[@]}" "Quit"; do 

	  case "$REPLY" in
		1 ) curlSetup;break;;
		2 ) gitSetup;break;;
		3 ) vimSetup;break;;
		4 ) agSetup;break;;
		5 ) xtermSetup;break;;
		6 ) tmuxSetup;break;;
		7 ) nodeSetup;break;;
		8 ) dockerSetup;break;;
		9 ) yarnSetup;break;;
		10 ) fontSetup;break;;
		11 ) keyboardSetup;break;;
		12 ) watchmanSetup;break;;
		13 ) setupAll;break;;

		$(( ${#options[@]}+1 )) ) echo "Goodbye!"; break;;
		*) echo "Invalid option.";continue;;
	  esac
	done

	if [ "$REPLY" != $(( ${#options[@]}+1 )) ] ; then
		applications
	fi
}

# Start the setup
setup
