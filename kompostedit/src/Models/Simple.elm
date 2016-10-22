module Models.Simple exposing (..)

import Html.App as App
import Html.App exposing (program, map)
import List exposing (length)
import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Json.Decode exposing (Decoder, andThen, succeed, list, string, object1, fail, (:=))
import Time exposing (Time, second, millisecond)
import Task
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode
import Json.Decode
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)
import JsonDecoding exposing (..)
import Process exposing (sleep)


type alias Model =
  { name: String
  , start: String
  , end: String
  }

type Msg
    = Update

initModel : Model
initModel = Model "" "" ""


update : Msg -> Model -> Model
update msg model =
    case msg of
        Update ->
            model


view : Model -> Html Msg
view model = text (toString model)



{--
main : Program Never
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
--}
main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }