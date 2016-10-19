module Models.Kompost exposing (..)

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
  , config: Config
  , mediaFile: Mediafile
  , segments: List Segment
  }

type alias Config =
    { width : Int
    , height : Int
    , framerate : Int
    , extensionType : String
    , duration : Int
    }

type alias Mediafile =
  { fileName: String
  , startingOffset: Int
  , checksum: String
  --, extension: String
  }

type alias Segment =
  { id: String
  , start: Int
  , end: Int
  }


init : (Model, Cmd Msg)
init = (initModel, getKompost)

initModel : Model
initModel = Model "" "" "" testConfig testMediaFile [testSegment1, testSegment2]

testConfig = Config 1280 1080 24 "mp4" 1234
testMediaFile = Mediafile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" 0 "A Checksum"
testSegment1 = Segment "Purple Mountains Clouds" 7541667 19750000
testSegment2 = Segment "Besseggen" 21250000  27625000

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


view : Model -> Html Msg
view model = text (toString model)



-- subscription
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


getKompost : Cmd Msg
getKompost = Task.perform FetchFail FetchSuccess <| Http.get decodeJson "https://raw.githubusercontent.com/StigLau/ElmMoro/master/kompostedit/test/resources/example.json"


main : Program Never
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
