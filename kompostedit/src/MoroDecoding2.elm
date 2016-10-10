module MoroDecoding2 exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.App as App
import Http
import Task
import Json.Encode
import Json.Decode
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)
import JsonDecoding exposing (..)

--https://noredink.github.io/json-to-elm/
randomJoke : Cmd Msg
randomJoke =
    let
        url = "https://raw.githubusercontent.com/StigLau/ElmMoro/master/kompostedit/test/resources/example.json"
        task =
            -- Http.getString url
            Http.get decodeJson url

        cmd =
            Task.perform FetchFail FetchSuccess task
    in
        cmd


-- model
type alias Model =
    String


initModel : Model
initModel = "Fetching Komposition..."


init : ( Model, Cmd Msg )
init = ( initModel, randomJoke )

-- update
type Msg
    = FetchSuccess JsonKomposition
    | FetchFail Http.Error
    | FetchKomposition


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchSuccess response ->
            (  "Komposition: " ++ (toString response.komposition) {-- ++ response.reference ++" " ++ (toString response.fileSizeChecksum)--}, Cmd.none )

        FetchFail error ->
            ( (toString error), Cmd.none )

        FetchKomposition ->
            ( "fetching reference ...", randomJoke )


-- view
view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchKomposition ] [ text "Fetch a Komposition" ]
        , br [] []
        , text model
        ]


-- subscription
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }