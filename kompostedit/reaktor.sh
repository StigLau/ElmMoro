rm main.js
elm-make src/Main.elm --output=main.js
echo "Force reload in browser. Go to http://localhost:8000/index.html"
elm-reactor