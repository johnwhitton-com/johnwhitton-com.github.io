# Getting Started

## Pre-requisites

```
# Ensure you have latest jeckyll compatible stable ruby version installed (3.1.3)
# https://www.engineyard.com/blog/how-to-install-ruby-on-a-mac-with-chruby-rbenv-or-rvm/
ruby-install 3.1.3
chruby ruby-3.1.3
```
## Getting Started
```
git clone https://github.com/johnwhitton-com/johnwhitton-com.github.io.git
cd johnwhitton-com.github.io/docs

# Install bundles and start server locally
bundle install
bundle exec jekyll serve

# View website at 
# https://localhost:4000
```

## Building a static site
```
bundle exec jekyll build
bundle exec jekyll serve
```

## Publish using github pages 
```
JEKYLL_ENV=production bundle exec jekyll build

# Push your commit for johnwhitton-com.github.io 
```

## Publish using github actions
We have forked [this repo](https://github.com/johnwhitton-com/jekyll4-deploy-gh-pages) and are following [these instructions](https://github.com/marketplace/actions/jekyll-4-build-deploy)
By committing the `jekyll4` branch it publishes to `gh-pages` which under the repository setting publishes every time.
