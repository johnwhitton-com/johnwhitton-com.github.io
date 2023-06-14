# John Whitton's Website

## Overview

This repository contains content published on <https://johnwhitton.com>

## Build Process

```bash

# Move into research web directory
cd research-web
# Copy the latest files from research, build and run the 
# cpr
./copy.sh; bundle exec jekyll serve

# cd johnwhitton-com.github.io
cd ../johnwhitton-com.github.io
# checkout a new branch
git checkout -b May2023
# copy latest content from research
cpr
rm -rf bridge
rm -rf code
rm -rf defi
rm -rf gaming
rm -rf misc
rm -rf primitives
rm -rf wallet
rm -rf zk

# build the site
bundle exec jekyll build
# bundle exec jekyll serve


# If the site looks good merge the code

# commit the code to the current Branch
# merge into main using a pull request

# To Publish the website
# merge into gh_pages
git checkout main
git pull
git checkout gh-pages
git merge main
git push



```
