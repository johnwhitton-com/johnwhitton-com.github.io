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

# Now update johnwhitton-com from research-web
# cd johnwhitton-com.github.io
cd ../johnwhitton-com.github.io
./copy.sh

# build the site
bundle exec jekyll build
# bundle exec jekyll serve

# Make sure to remove research and posts that are WIP
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
