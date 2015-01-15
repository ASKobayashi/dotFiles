# ASKobayashi's Dot Files
This dotfile installation process was stolen from my good friend @xedmada (http://github.com/xedmada/dotFiles

## How it works
dotFiles/dotstrap.sh is a script inspired by [@holman](https://github.com/holman)'s [holman/dotfiles](https://github.com/holman/dotfiles).

### Behavior:
- Files and directories ending in an underscore '_' are ignored.
- Files and directories beginning in a capital letter are symlinked to your home directory.
- Files and directories beginning in a lowercase letter are symlinked to your home directory as hidden '.' files.


### dotstrap.sh:
If run on its own it will assess if you are on a linux or osx system and install dotfiles accordingly. It probably does a lot of stuff you wouldn't like such as install fish and making it your default shell.


    usage: dotstrap.sh --auto|osx|linux|fish|bash|help [--trial]

      --auto            Automagically install a new system

      --osx             Install a new OSX system

      --linux           Install a new linux system

      --link            Link all dotfiles

      --fish            Link dotfiles for Fish and Bash only

      --bash            Link dotfiles for Bash only

      --help | -h       Woh, meta...

      --trial           Optional. Dry-run links



## Installation

You probably shouldn't be using this unless you already know what you are doing.

	git clone https://github.com/XedMada/dotFiles.git ~/dotFiles
	cd ~/dotfiles/setup_/
    dotstrap.sh

