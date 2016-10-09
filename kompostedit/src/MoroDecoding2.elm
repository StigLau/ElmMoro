module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.App as App
import Http
import Task
import Json.Encode
import Json.Decode
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)

--https://noredink.github.io/json-to-elm/


randomJoke : Cmd Msg
randomJoke =
    let
        url = "https://raw.githubusercontent.com/StigLau/ElmMoro/master/kompostedit/test/resources/example.json"
        task =
            -- Http.getString url
            Http.get decodeSomething url

        cmd =
            Task.perform Fail Joke task
    in
        cmd


-- model


type alias Model =
    String


initModel : Model
initModel =
    "Finding a reference..."


init : ( Model, Cmd Msg )
init =
    ( initModel, randomJoke )



-- update


type Msg
    = Joke Komposition
    | Fail Http.Error
    | NewJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke response ->
            (  "Komposition: " ++ (toString response.komposition) {-- ++ response.reference ++" " ++ (toString response.fileSizeChecksum)--}, Cmd.none )

        Fail error ->
            ( (toString error), Cmd.none )

        NewJoke ->
            ( "fetching reference ...", randomJoke )



-- view


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick NewJoke ] [ text "Fetch a Joke" ]
        , br [] []
        , text model
        ]



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Komposition =
    { komposition : SomethingKomposition
    }

type alias SomethingKompositionMediaFile =
    { fileName : String
    , startingOffset : Int
    , checksum : String
    , bpm : Int
    }

type alias SomethingKomposition =
    { mediaFile : SomethingKompositionMediaFile
    }

decodeSomething : Json.Decode.Decoder Komposition
decodeSomething =
    Json.Decode.Pipeline.decode Komposition
        |> Json.Decode.Pipeline.required "komposition" (decodeSomethingKomposition)

decodeSomethingKompositionMediaFile : Json.Decode.Decoder SomethingKompositionMediaFile
decodeSomethingKompositionMediaFile =
    Json.Decode.Pipeline.decode SomethingKompositionMediaFile
        |> Json.Decode.Pipeline.required "fileName" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "startingOffset" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "checksum" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "bpm" (Json.Decode.int)

decodeSomethingKomposition : Json.Decode.Decoder SomethingKomposition
decodeSomethingKomposition =
    Json.Decode.Pipeline.decode SomethingKomposition
        |> Json.Decode.Pipeline.required "mediaFile" (decodeSomethingKompositionMediaFile)

encodeSomething : Komposition -> Json.Encode.Value
encodeSomething record =
    Json.Encode.object
        [ ("komposition",  encodeSomethingKomposition <| record.komposition)
        ]

encodeSomethingKompositionMediaFile : SomethingKompositionMediaFile -> Json.Encode.Value
encodeSomethingKompositionMediaFile record =
    Json.Encode.object
        [ ("fileName",  Json.Encode.string <| record.fileName)
        , ("startingOffset",  Json.Encode.int <| record.startingOffset)
        , ("checksum",  Json.Encode.string <| record.checksum)
        , ("bpm",  Json.Encode.int <| record.bpm)
        ]

encodeSomethingKomposition : SomethingKomposition -> Json.Encode.Value
encodeSomethingKomposition record =
    Json.Encode.object
        [ ("mediaFile",  encodeSomethingKompositionMediaFile <| record.mediaFile)
        ]