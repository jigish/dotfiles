#!/bin/bash

[[ ! -x $(which brew) ]] && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew upgrade
brew upgrade --cask
brew install --cask $(cat ~/dotfiles/brew-casks.txt)
brew install $(cat ~/dotfiles/brews.txt)

pip2 install --upgrade pip
pip2 install --upgrade pynvim
pip3 install --upgrade pip
pip3 install --upgrade pynvim
