module Models.Simple exposing (..)

import Html.App as App
import Html.App exposing (program, map)
import List exposing (length)
import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Time exposing (Time, second, millisecond)
import Html exposing (..)
import Html.Events exposing (..)
import Process exposing (sleep)
import String
import Models.KompostRemoting exposing (..)

type alias Model =
  { name: String
  , start: String
  , end: String
  , hats : List String
  }

initModel : (Model, Cmd Msg)
initModel = (Model "" "" "" [], executeKompostStorage)

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