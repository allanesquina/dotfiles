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
setup() {
	# Local vars 
	DOTFILES=$HOME/dotfiles
	DOTREPO=https://github.com/allanesquina/dotfiles.git

	myecho "Updating"
	sudo apt-get update

	# CURL
	myecho "CURL"
	sudo apt install curl
	sayok

	# GIT
	myecho "GIT"
	sudo apt install git
	sayok

	myecho "GIT global config"
	git config --global user.name "Allan Esquina"
	git config --global user.email "loloudxur@gmail.com"
	sayok

	# Verify if dotfiles folder exists
	if [ "$DOTFILES" ]; then
		myecho "Removing dotfiles"
		rm -rf $DOTFILES
		sayok
	fi

	myecho "Downloading dotfiles from github into ${DOTFILES}"
	git clone $DOTREPO $DOTFILES 
	sayok

	# Applications
	applications
	docker
	yarn

	#fonts
	fonts

	# Keyboard configuration
	myecho "Configuring Keyboard speed rate"
	xset r rate 185 70
	sayok

}

applications() {
	# Vim instalation
	myecho "Vim"
	sudo apt install vim
	ln -s $DOTFILES/vim/vimrc $HOME/.vimrc
	sayok
	# Node Instalation
	myecho "NodeJS By NVM"
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
	nvm install 8
	sayok
	# Tmux instalation
	myecho "Tmux"
	sudo apt install tmux
	ln -s $DOTFILES/tmux.conf $HOME/.tmux.conf
	sayok
	# Xterm Config
	myecho "Xterm"
	sudo apt-get install xterm
	ln -s $DOTFILES/Xresources.hybird $HOME/.Xdefaults
	xrdb .Xdefaults
	sayok
	# Ag search
	myecho "Ag search"
	sudo apt-get install silversearcher-ag 
	sayok
}

docker() {
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

yarn() {
	myecho "Yarn"
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -                                                                                                   
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list                                                                       
	sudo apt-get update                                                                                                                                                      
	sudo apt-get install --no-install-recommends yarn  
	sayok
}

fonts() {
    myecho "Fonts"
    sudo cp $DOTFILES/fonts/*.ttf /usr/share/fonts/TTF/
    sudo cp $DOTFILES/fonts/*.otf /usr/share/fonts/OTF/
    fc-cache
    sayok
}

# Start the setup
setup

