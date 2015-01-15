#!/bin/bash

# Make sure we’re using the latest Homebrew
brew update


# Upgrade any already-installed formulae
brew upgrade


# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

brew install gnutls


# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils


# Install Bash 4
brew install bash


# Install wget with IRI support
brew install wget --enable-iri


# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep


# Install everything else
brew install ack
brew install git
brew install gist
brew install sqlite
brew install mysql
brew install ctags
brew install curl
brew install ettercap
brew install bash-completion
brew install nmap
brew install python
brew install ffmpeg
brew install libxml2
brew install mtr --no-gtk
brew install libfreenect
brew install opencv
brew install aspell --lang=en
brew install weechat --with-aspell --with-ruby --with-python --with-lua --with-perl
brew install gnupg
brew install imagemagick
brew install xmlstarlet
brew install fdupes



# Remove outdated versions from the cellar
brew cleanup
