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
import Html.Attributes exposing (..)
import Http
import String
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
    | SetSegmentName String
    | SetSegmentStart String
    | SetSegmentEnd String
    | Create
    | Save

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchSuccess response ->
            (  model, Cmd.none )

        FetchFail error ->
            ( model, Cmd.none )

        FetchKomposition ->
            ( model, getKompost )

        SetSegmentName name -> ({ model | name  = name  }, Cmd.none)
        SetSegmentStart start -> ({ model | start = start }, Cmd.none)
        SetSegmentEnd end -> ({ model | end = end }, Cmd.none)


        Create -> (model, Cmd.none)

        Save ->
                    if (String.isEmpty model.name) then
                        (model, Cmd.none)
                    else
                        (save model, Cmd.none)

save : Model -> Model
save model =
      case (isInputfieldsValid model, (isEditingExistingSegment model))
      of
        (True, False) -> add model
        (True, True)  -> updateChanges model
        _ -> model

add : Model -> Model
add model =
    let
        segment =
            Segment model.name (validNr model.start) (validNr model.end)

        newSegments =
            segment :: model.segments
    in
        { model
            | segments = newSegments
            , name = ""
            , start = ""
            , end = ""
        }

updateChanges : Model -> Model
updateChanges model =
    let
        newSegments =
            List.map
                (\segment ->
                    if segment.id == model.name then
                        { segment | start = (validNr model.start), end = (validNr model.end) }
                    else
                        segment
                )
                model.segments
    in
        { model
            | segments = newSegments
            , name = ""
            , start = ""
            , end = ""
        }


isInputfieldsValid: Model -> Bool
isInputfieldsValid model =
  not(validateSegmentFields model)
      && isValidNr model.start
      && isValidNr model.end
      && (validNr model.end) > (validNr model.start)

isValidNr : String -> Bool
isValidNr value =
  case String.toInt value of
    Ok int ->
      int >= 0
    Err _ ->
      False

validNr : String -> Int
validNr value =
  case String.toInt value of
    Ok int ->
      int
    Err _ ->
      -1

validateSegmentFields: Model -> Bool
validateSegmentFields model = (String.isEmpty model.name)


isEditingExistingSegment: Model-> Bool
isEditingExistingSegment model =
  List.length( List.filter (\s -> s.id == model.name) model.segments ) == 1


view : Model -> Html Msg
view model =
 div [ class "scoreboard" ]
        [ h1 [] [ text "Kompost dvl editor" ]
--        , [ button [ onClick FetchKomposition ] [ text "Fetch a Komposition" ] ]
        , segmentForm model
        , text "Komposition: ", text (toString model)
        ]

segmentForm : Model -> Html Msg
segmentForm model =
    Html.form [ ]
        [ input
            [ type' "text"
            , placeholder "Segment Name"
            , onInput SetSegmentName
            , Html.Attributes.value model.name
            ] []
        , input
            [ type' "number"
            , placeholder "Start"
            , onInput SetSegmentStart
            , Html.Attributes.value model.start
            ] []
        , input
            [ type' "number"
            , placeholder "End"
            , onInput SetSegmentEnd
            , Html.Attributes.value model.end
            ] []
        , button [ type' "button", onClick Save ] [ text "Save" ]
        ]

-- subscription
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


getKompost : Cmd Msg
getKompost = Task.perform FetchFail FetchSuccess <| Http.get decodeJson "https://raw.githubusercontent.com/StigLau/ElmMoro/master/kompostedit/test/resources/example.json"


main : Program Never
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
