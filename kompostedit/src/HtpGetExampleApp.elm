module Main exposing (..)

import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)
import Html.App
import Http
import Task exposing (Task)
import Json.Decode as Decode


-- MODEL
type alias Model = String

init : ( Model, Cmd Msg )
init = ( "", fetchCmd "3")

-- MESSAGES
type Msg
    = Fetch String
    | FetchSuccess String
    | FetchError Http.Error

-- VIEW
view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (Fetch "2") ] [ text "Fetch" ]
        , text model
        ]

decode : Decode.Decoder String
decode = Decode.at [ "name" ] Decode.string


fetchTask : String -> Task Http.Error String
fetchTask url = Http.get decode url


fetchCmd : String -> Cmd Msg
fetchCmd planet = Task.perform FetchError FetchSuccess (fetchTask ("http://swapi.co/api/planets/"++ planet++ "/?format=json"))



-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch planet ->
            ( model, (fetchCmd planet))

        FetchSuccess name ->
            ( name, Cmd.none )

        FetchError error ->
            ( toString error, Cmd.none )

-- MAIN
main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }