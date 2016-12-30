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
import Models.Kompost as Kompost

--https://noredink.github.io/json-to-elm/


-- model
type alias Model =
    String


initModel : Model
initModel = "Fetching Komposition..."


init : ( Model, Cmd Kompost.Msg )
init = ( initModel, Kompost.getKompost )

-- update
type Msg
    = FetchSuccess JsonKomposition
    | FetchFail Http.Error
    | FetchKomposition


update : Msg -> Model -> ( Model, Cmd Kompost.Msg )
update msg model =
    case msg of
        FetchSuccess response ->
            (  "Komposition: " ++ (toString response.komposition) {-- ++ response.reference ++" " ++ (toString response.fileSizeChecksum)--}, Cmd.none )

        FetchFail error ->
            ( (toString error), Cmd.none )

        FetchKomposition ->
            ( "jalla", Kompost.getKompost )

-- view
view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchKomposition ] [ text "Fetch a Komposition" ]
        , br [] []
        , text model
        ]


-- subscription
subscriptions : Model -> Sub Kompost.Msg
subscriptions model = Sub.none

main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }