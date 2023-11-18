#!/usr/bin zsh

#setup email
git config user.email "nihongojaydee@gmail.com"

#unset signing format
git config --unset gpg.format

#set signing format to ssh
git config gpg.format ssh

#add key for signing
git config user.signingKey ~/.ssh/personal_25519.pub

#set signing to all commits
git config commit.gpgsign true
