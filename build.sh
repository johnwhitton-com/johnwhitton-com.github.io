pushd ~/johnwhitton/developer-playground
mkdocs build
popd
cp -rf ../developer-playground/site/ ./docs
# rsync -a -v --delete-after ../developer-playground/site/ ./harmony
