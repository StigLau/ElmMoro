module Models.Listings exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http


type alias Model = {
    something: String
    }

type Msg = DoSometing

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoSometing ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "listings" ]
        [ h1 [] [ text "Listing stuff" ]
        , div [] [ text "Komposition: " ]
        , text (toString model)
        , div [] [ ]
        ]



init : ( Model, Cmd Msg )
init = ( Model "Somethingss", Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
