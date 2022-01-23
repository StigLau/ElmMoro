
Switche mellom ID og url i Source
=================================

Building release file
=====================
elm make src/Main.elm --output target/elm/kompost.js
Installation to capra kompo.se/edit bucket

Getting Canonical ID for file permissions
-----------------------------------------
aws s3api list-buckets --query Owner.ID --output text

Elm Maintenance
===============

elm-json tree
elm-json uninstall the-sett/elm-aws-core


Current status
==============
Authentication URL: https://auth.kompo.st/login?client_id=23v0j4t4jbsl2krje5q2vk5uup&response_type=token&scope=email+openid+profile&redirect_uri=https://app.kompo.st/lifter
Authentication info isn't sent to API-gateway in the form we wish, resulting in, amongst others kompost/_find .... 401s


Pipedream for web debugging
===========================
https://pipedream.com/@s10g?tab=workflows - s...l@google . Verify endpoint https://enq45xmnlt5mh9t.m.pipedream.net 