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
    | RemoteFail Http.Error
    | StoreSuccess (List String)

initModel : (Model, Cmd Msg)
initModel = (Model "" "" "" [], (storeKompost (storeKompostRequest "http://localhost:9099/store/kompost" "Send this" ) ))

storeKompost : Task.Task Http.Error (List String) -> Cmd Msg
storeKompost request = Task.perform RemoteFail StoreSuccess request

storeKompostRequest : String -> String -> Task.Task Http.Error (List String)
storeKompostRequest requestString destination = Http.post (list string) destination (Http.string requestString)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Update ->
            (model, Cmd.none)

        RemoteFail _ ->
            (model, Cmd.none)

        StoreSuccess strings ->
            ({model | hats = strings }, Cmd.none)

view : Model -> Html Msg
view model = div [ ] [ text (String.join "," model.hats ) ]

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