cp -rf ../research-web/index.html .
cp -rf ../research-web/*.md .
cp -rf ../research-web/*.yml .
rm -rf ./_about/*
cp -rf ../research-web/_about/* ./_about/.
rm -rf ./_data/*
cp -rf ../research-web/_data/* ./_data/.
rm -rf ./_work/*
cp -rf ../research-web/_work/* ./_work/.
rm -rf ./_layouts/*
cp -rf ../research-web/_layouts/* ./_layouts/.
rm -rf ./_sass/*
cp -rf ../research-web/_sass/* ./_sass/.
rm -rf ./_includes/*
cp -rf ../research-web/_includes/* ./_includes/.

rm -rf ./_posts/*
cp -rf ../research-web/_posts/* _posts
rm -rf ./assets/posts/*
cp -rf ../research-web/assets/posts/* assets/posts
cp -rf ../research-web/assets/images/* assets/images
rm -rf ./_research/*
cp -rf ../research-web/_research/* _research
rm -rf ./assets/research/*
cp -rf ../research-web/assets/research/* assets/research

# rm -rf ./_research/bridge
# rm -rf ./_research/code
rm -rf ./_research/defi
rm -rf ./_research/gaming
rm -rf ./_research/misc
# rm -rf ./_research/misc
# rm -rf ./_research/primitives
rm -rf ./_research/wallet
# rm -rf ./_research/zk

# Clean up layouts for research and posts


bundle exec jekyll build
# bundle exec jekyll serve