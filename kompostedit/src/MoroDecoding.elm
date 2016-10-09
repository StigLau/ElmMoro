module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.App as App
import Http
import Task
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias Response =
    { fileSizeChecksum : Int
    , reference : String
    , categories : List String
    }


responseDecoder : Decoder Response
responseDecoder =
    decode Response
        |> required "fileSizeChecksum" int
        |> required "reference" string
        |> optional "categories" (list string) []
        |> at [ "komposition" ]


randomJoke : Cmd Msg
randomJoke =
    let
        url = "https://raw.githubusercontent.com/StigLau/ElmMoro/master/kompostedit/test/resources/example.json"
        task =
            -- Http.getString url
            Http.get responseDecoder url

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
    = Joke Response
    | Fail Http.Error
    | NewJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke response ->
            (  "Komposition: " ++ response.reference ++" " ++ (toString response.fileSizeChecksum), Cmd.none )

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
