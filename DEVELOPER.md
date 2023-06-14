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

```bash
bundle exec jekyll build
bundle exec jekyll serve
```

## Publish using github actions

We have forked [this repo](https://github.com/johnwhitton-com/jekyll4-deploy-gh-pages) and have set up a [worfklow to publish](./.github/_site/workflows/main.yml).

By committing the `jekyll4` branch it publishes to `gh-pages` which, under the repository setting, publishes to `main` on each commit.

## Copying content from Research

Content can be developed in [research](https://github.com/johnwhitton/research) repository and copied here for publishing.

```bash
./copy.sh; bundle exec jekyll serve
```
