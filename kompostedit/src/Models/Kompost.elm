module Models.Kompost exposing (..)

import List exposing (length)
import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Json.Decode exposing (..)
import Time exposing (Time, second, millisecond)
import Task
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http
import String
import JsonDecoding exposing (..)
import Process exposing (sleep)
import Functions exposing (..)
import Models.KompostModels exposing (..)

import Models.ServerApi exposing (..)



init : ( Model, Cmd Msg )
init =
    ( initModel, getKompost )


initModel : Model
initModel =
    Model "" "" "" testConfig testMediaFile [ testSegment1, testSegment2 ]


testConfig =
    Config 1280 1080 24 "mp4" 1234


testMediaFile =
    Mediafile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" 0 "A Checksum"


testSegment1 =
    Segment "Purple Mountains Clouds" 7541667 19750000


testSegment2 =
    Segment "Besseggen" 21250000 27625000


type Msg
    = FetchSuccess JsonKomposition
    | FetchFail Http.Error
    | FetchKomposition
    | SetSegmentName String
    | SetSegmentStart String
    | SetSegmentEnd String
    | Create
    | Save
    | ShowArtist  (Result Http.Error Artist)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchSuccess response ->
            ( model, Cmd.none )

        FetchFail error ->
            ( model, Cmd.none )

        FetchKomposition ->
            ( model, getKompost )

        SetSegmentName name ->
            ( { model | name = name }, Cmd.none )

        SetSegmentStart start ->
            ( { model | start = start }, Cmd.none )

        SetSegmentEnd end ->
            ( { model | end = end }, Cmd.none )

        Create ->
            ( model, Cmd.none )

        Save ->
            if (String.isEmpty model.name) then
                ( model, Cmd.none )
            else
                ( save model, Cmd.none )

        ShowArtist res ->
             case res of
                 Result.Ok artist ->
                     ( { model
                         | name = artist.name
                         --, start = artist.id
                       }, Cmd.none )

                 Result.Err err ->
                     let _ = Debug.log "Error retrieving artist" err
                     in
                         (model, Cmd.none)

save : Model -> Model
save model =
    case
        ( isInputfieldsValid model, (isEditingExistingSegment model) )
    of
        ( True, False ) ->
            add model

        ( True, True ) ->
            updateChanges model

        _ ->
            model


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Kompost dvl editor" ]
          --        , [ button [ onClick FetchKomposition ] [ text "Fetch a Komposition" ] ]
        , segmentForm model
        , text "Komposition: "
        , text (toString model)
        ]


segmentForm : Model -> Html Msg
segmentForm model =
    Html.form []
        [ input
            [ type_ "text"
            , placeholder "Segment Name"
            , onInput SetSegmentName
            , Html.Attributes.value model.name
            ]
            []
        , input
            [ type_ "number"
            , placeholder "Start"
            , onInput SetSegmentStart
            , Html.Attributes.value model.start
            ]
            []
        , input
            [ type_ "number"
            , placeholder "End"
            , onInput SetSegmentEnd
            , Html.Attributes.value model.end
            ]
            []
        , button [ type_ "button", onClick Save ] [ text "Save" ]
        ]



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getKompost : Cmd Msg
getKompost = getArtist 1 ShowArtist
    -- Task.perform FetchFail FetchSuccess <| Http.get "https://raw.githubusercontent.com/StigLau/ElmMoro/master/kompostedit/test/resources/example.json" decodeJson


main : Program Never Model Msg
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
