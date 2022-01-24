Building elm files
==================
elm make src/Main.elm --output src/js/kompost.js
upload src/js/kompost.js to s3://app.kompo.st/js/

Switche mellom ID og url i Source
=================================

When dependencies are borked
============================
elm-json upgrade


Testing locally
=======
Start up
no.lau.kompost.Kompost kvaern
config kvaern-prod.properties
then run 

Goto
-------
http://0.0.0.0:8001/src/
