module Switcharoo exposing (..)

import Html.App as App
import Html exposing (..)
import Html.App exposing (program, map)
import Html.Attributes exposing (class)
import Http
import Task
import Models.Simple as Simple
import Time exposing (Time, second, millisecond)
import JsonDecoding exposing (..)

type alias Model = {
    simple: Simple.Model
    }

initModel : Model
initModel = Model Simple.initModel

init : (Model, Cmd Msg)
init = (initModel, getKompost)


type Msg
    = FetchSuccess JsonKomposition
    | FetchFail Http.Error
    | FetchKomposition

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchSuccess response ->
            (  model, Cmd.none )

        FetchFail error ->
            ( model, Cmd.none )

        FetchKomposition ->
            ( model, getKompost )

getKompost : Cmd Msg
getKompost = Task.perform FetchFail FetchSuccess <| Http.get decodeJson "https://raw.githubusercontent.com/StigLau/ElmMoro/master/kompostedit/test/resources/example.json"

view : Model -> Html Msg
view model =
        text("Hello")
--        [ map (\_ -> getKompost) (Simple.view model.simple) ]

subscription : Model -> Sub Msg
subscription model = Sub.none

main : Program Never
main =
    App.beginnerProgram
        { model = init
        , view = view
        , update = update
        }


