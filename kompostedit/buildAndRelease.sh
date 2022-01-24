#!/bin/sh
elm make src/Main.elm --output release/content/elm/kompost.js
echo "Finished building. Pushing to https://app.kompo.st/index.html"
cd release
terraform apply
cd ..
echo "Finished"