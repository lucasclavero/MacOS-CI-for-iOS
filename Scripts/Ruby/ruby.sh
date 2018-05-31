#!/bin/sh

brew install rbenv

eval "$(rbenv init -)"
rbenv install -s 2.2.3
rbenv rehash
rbenv global 2.2.3


#install bundler
gem install bundler

#update 2.31
