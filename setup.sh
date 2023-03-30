#!/usr/bin/env bash

echo "Installing software needed to run Jekyll locally... "

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

rvm use 
gem install bundler 
gem install pkg-config
gem install nokogiri
# bundle config build.nokogiri --use-system-libraries
bundle install --path vendor/bundle
echo "Done."
