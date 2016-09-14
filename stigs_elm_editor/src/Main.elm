module Main exposing (..)

import Model exposing(initModel)
import View exposing (view)
import Controller exposing(update)
import Html.App as App



main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
