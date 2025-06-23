
Switche mellom ID og url i Source
=================================

Setting up local dev environment
================================
Run "elm reactor" from kompostedit root. Follow to http://localhost:8000/index_without_auth.html
This should start the app with testdata.
Beware that you may need to run "elm make src....." below to update the running code of the app

Building release file
=====================
elm make src/Main.elm --output release/content/elm/kompost.js
elm make src/CustomerMedia/FileUpload.elm --output release/content/elm/fileupload.js
upload release/content/elm/kompost.js to PRIVATE s3://app.kompo.st/elm/
Can be done via "terraform apply from release dir"

Installation to capra kompo.se/edit bucket

Extreme packaging
=================
elm make src/Main.elm --optimize --output=elm.js
uglifyjs elm.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" | uglifyjs --mangle --output elm.min.js
https://github.com/elm/compiler/blob/master/hints/optimize.md

Getting Canonical ID for file permissions
-----------------------------------------
aws s3api list-buckets --query Owner.ID --output text

Elm Maintenance
===============
elm-json upgrade
elm-json tree
elm-json uninstall the-sett/elm-aws-core


Current status
==============
Authentication URL: https://auth.kompo.st/login?client_id=23v0j4t4jbsl2krje5q2vk5uup&response_type=token&scope=email+openid+profile&redirect_uri=https://app.kompo.st/lifter
Authentication info isn't sent to API-gateway in the form we wish, resulting in, amongst others kompost/_find .... 401s


Pipedream for web debugging
===========================
https://pipedream.com/@s10g?tab=workflows - s...l@google . Verify endpoint https://enq45xmnlt5mh9t.m.pipedream.net

Testing locally
=======
Start up
no.lau.kompost.Kompost kvaern
config kvaern-prod.properties
then run

Goto
-------
http://0.0.0.0:8001/src/


NOTE: Jeg skriver kompost id feil. Nå er det full URL.
av s3://kompo-customer-storage/long-term-availability/b3ch/IMG_4262.MOV 
Burde kun inneholde b3ch/IMG_4262.MOV 