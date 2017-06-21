module UI.Theme exposing (..)

import Bootstrap.Button exposing (onClick)
import Bootstrap.CDN
import Bootstrap.Card as Card
import CDN
import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import RemoteData exposing (RemoteData(..), WebData, isLoading)
import Html.Events exposing (onInput)


theme : Bool -> Html msg
theme showLoadingIndicator =
    let
        paceConfig =
            Html.node "script" [] [ text """
window.paceOptions = {
    ajax: {
        trackMethods: ["GET", "POST", "PUT", "DELETE", "REMOVE"]
    },
    restartOnRequestAfter: true
};

        """ ]

        paceTheme =
            Html.node "style" [] [ text """
.pace {
  -webkit-pointer-events: none;
  pointer-events: none;

  -webkit-user-select: none;
  -moz-user-select: none;
  user-select: none;

  position: fixed;
  top: 0;
  left: 0;
  width: 100%;

  -webkit-transform: translate3d(0, -50px, 0);
  -ms-transform: translate3d(0, -50px, 0);
  transform: translate3d(0, -50px, 0);

  -webkit-transition: -webkit-transform .5s ease-out;
  -ms-transition: -webkit-transform .5s ease-out;
  transition: transform .5s ease-out;
}

.pace.pace-active {
  -webkit-transform: translate3d(0, 0, 0);
  -ms-transform: translate3d(0, 0, 0);
  transform: translate3d(0, 0, 0);
}

.pace .pace-progress {
  display: block;
  position: fixed;
  z-index: 2000;
  top: 0;
  right: 100%;
  width: 100%;
  height: 10px;
  background: #8776dd;

  pointer-events: none;
}        """ ]

        loading =
            if showLoadingIndicator then
                [ paceConfig
                , Html.node "script" [ Html.Attributes.src "https://cdnjs.cloudflare.com/ajax/libs/pace/1.0.2/pace.min.js" ] []
                , paceTheme
                ]
            else
                [ text "" ]
    in
        span [] <|
            [ Bootstrap.CDN.stylesheet
            , .css CDN.fontAwesome
            ]
                ++ loading