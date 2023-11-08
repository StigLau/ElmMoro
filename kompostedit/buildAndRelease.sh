#!/bin/sh
echo "Building and releasing to kompo.se"
elm make src/CustomerMedia/FileUpload.elm --output release/content/elm/fileupload.js && \
elm make src/Main.elm --output release/content/elm/kompost.js && \
aws s3 cp release/content/elm s3://api.kompo.se/elm/ --recursive
#elm reactor
