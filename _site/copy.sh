cp -rf ../research-web/index.html .
cp -rf ../research-web/*.md .
cp -rf ../research-web/*.yml .
rm -rf ./_about/*
cp -rf ../research-web/_about/* ./_about/.
rm -rf ./_work/*
cp -rf ../research-web/_work/* ./_work/.
rm -rf ./_layouts/*
cp -rf ../research-web/_layouts/* ./_layouts/.

rm -rf ./_posts/*
cp -rf ../research-web/_posts/* _posts
rm -rf ./assets/posts/*
cp -rf ../research-web/assets/posts/* assets/posts
rm -rf ./_research/*
cp -rf ../research-web/_research/* _research
rm -rf ./assets/research/*
cp -rf ../research-web/assets/research/* assets/research

rm -rf ./_research/bridge
rm -rf ./_research/code
rm -rf ./_research/defi
rm -rf ./_research/gaming
rm -rf ./_research/misc
rm -rf ./_research/primitives
rm -rf ./_research/wallet
rm -rf ./_research/zk