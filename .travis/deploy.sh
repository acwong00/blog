#!/bin/bash

openssl aes-256-cbc -K $encrypted_15db670b9b95_key -iv $encrypted_15db670b9b95_iv -in .travis/id_rsa_travis.enc -out ~/.ssh/id_rsa -d

chmod 600 ~/.ssh/id_rsa

eval $(ssh-agent)

ssh-add ~/.ssh/id_rsa

cp .travis/ssh_config ~/.ssh/config

git config --global user.name "acwong"
git config --global user.email acwong00@gmail.com

git clone git@github.com:acwong00/blog.git .deploy_git

hexo d