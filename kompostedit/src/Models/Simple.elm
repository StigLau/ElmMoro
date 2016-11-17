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
import String


type alias Model =
  { name: String
  , start: String
  , end: String
  , hats : List String
  }

type Msg
    = Update
    | GetFailed Http.Error
    | GetSucceeded (List String)

initModel : (Model, Cmd Msg)
initModel = (Model "" "" "" [], storeKompost)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Update ->
            (model, Cmd.none)

        GetFailed _ ->
            (model, Cmd.none)

        GetSucceeded strings ->
            ({model | hats = strings }, Cmd.none)


view : Model -> Html Msg
view model = div [ ] [ text (String.join "," model.hats ) ]

storeKompost : Cmd Msg
storeKompost = Task.perform GetFailed GetSucceeded storeKompostRequest

storeKompostRequest : Task.Task Http.Error (List String)
storeKompostRequest = Http.post (list string) "http://localhost:9099/store/kompost" (Http.string kompostur)


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never
main =
    App.program
        { init = initModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

kompostur = """Here is something simple to send"""