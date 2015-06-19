#!/bin/bash

# Make sure we’re using the latest Homebrew
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils


# Remove outdated versions from the cellar
brew cleanup
