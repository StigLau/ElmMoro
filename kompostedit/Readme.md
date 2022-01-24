
Switche mellom ID og url i Source
=================================

Building release file
=====================
elm make src/Main.elm --output release/content/elm/kompost.js
upload release/content/js/kompost.js to s3://app.kompo.st/js/
Can be done via "terraform apply from release dir"

Installation to capra kompo.se/edit bucket

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
