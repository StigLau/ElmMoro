require('./main.css');
var logoPath = require('./logo.svg');
var Elm = require('./Main.elm');

var root = document.getElementById('root');

Elm.Main.embed(root);

console.log("MORDI ER EI GEIT, helt i starten");