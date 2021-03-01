#!/bin/bash

git checkout source
bundle exec jekyll build
git add .
git commit -m "$1"
git branch -D master
git checkout -b master
git filter-branch --subdirectory-filter _site -f HEAD
git push --all
git checkout source
