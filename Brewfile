# Brewfile for NoirCon project

# Install bash
brew install bash

# Install coreutils
brew install coreutils


# Custom script setup
system "curl -o /usr/local/bin/noircon https://raw.githubusercontent.com/binarynoir/noircon/main/noircon"
system "chmod +x /usr/local/bin/noircon"

# Install the man page
system "curl -o /usr/local/share/man/man1/noircon.1 https://raw.githubusercontent.com/binarynoir/noircon/main/noircon.1"
system "man -c /usr/local/share/man/man1/noircon.1"
