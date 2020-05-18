module Auth.Top exposing (main)

import Browser
import Auth.Main exposing (Model, Msg, init, update, view)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
