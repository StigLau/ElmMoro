module Models.Kompost exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http
import Functions exposing (..)
import Models.KompostModels exposing (..)

import Models.KompostApi exposing (getKompo, updateKompo, Komposition)



init : ( Model, Cmd Msg )
init = ( initModel, (getKompo "4317d37968f8b991c5cd28a86e71d9ca" FetchKompostResponseHandler) )


initModel : Model
initModel = Model "Fine clouds" 0 123456 testConfig testMediaFile [ testSegment1, testSegment2 ]


testConfig = Config 1280 1080 24 "mp4" 1234


testMediaFile = Mediafile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" 0 "A Checksum"


testSegment1 = Segment "Purple Mountains Clouds" 7541667 19750000


testSegment2 = Segment "Besseggen" 21250000 27625000


type Msg
    -- Remoting Operations
    = NewOrUpdate
    | StoreKomposition
    | FetchKomposition
    | FetchKompostResponseHandler (Result Http.Error Komposition)
    -- Alter Segment
    |  SetSegmentName String
    | SetSegmentStart String
    | SetSegmentEnd String
    -- Alter Media File
    | SetMediaFileLocation String
    | SetMediaFileChecksum String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchKomposition ->
            ( model, getKompo "Fetch identity" FetchKompostResponseHandler )

        StoreKomposition ->
            ( model, updateKompo (Komposition model.name model.mediaFile model.segments) FetchKompostResponseHandler )

        SetSegmentName name ->
            ( { model | name = name }, Cmd.none )

        SetSegmentStart start ->
            ( { model | start = (validNr start) }, Cmd.none )

        SetSegmentEnd end ->
            ( { model | end = (validNr end) }, Cmd.none )

        SetMediaFileLocation fileLocation ->
            ( { model | mediaFile = (updateFileLocation model.mediaFile fileLocation)}, Cmd.none )

        SetMediaFileChecksum checksum ->
            ( { model | mediaFile = (updateMediaChecksum model.mediaFile checksum)}, Cmd.none )

        NewOrUpdate ->
            if (String.isEmpty model.name) then
                ( model, Cmd.none )
            else
                ( newOrUpdate model, Cmd.none )

        FetchKompostResponseHandler res ->
             case res of
                 Result.Ok komposition ->
                     ( { model
                         | name = komposition.name
                         , segments = komposition.segments
                       }, Cmd.none )

                 Result.Err err ->
                     let _ = Debug.log "Error retrieving komposition" err
                     in
                         (model, Cmd.none)

updateFileLocation: Mediafile -> String -> Mediafile
updateFileLocation mediaFile fileLocation = { mediaFile | fileName = fileLocation}

updateMediaChecksum: Mediafile -> String -> Mediafile
updateMediaChecksum mediaFile checksum = { mediaFile | checksum = checksum}



newOrUpdate : Model -> Model
newOrUpdate model =
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
        , mediafileForm model
        , div [] [ text "Komposition: " ]
        , text (toString model)
        , div [] [ ]
        , button [ type_ "button", onClick StoreKomposition ] [ text "Store Komposition" ]
        ]


segmentForm : Model -> Html Msg
segmentForm model =
    Html.form []
        [
        div [] [ text "Name | Start | End" ]
        , input
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
            , Html.Attributes.value (toString model.start)
            ]
            []
        , input
            [ type_ "number"
            , placeholder "End"
            , onInput SetSegmentEnd
            , Html.Attributes.value (toString model.end)
            ]
            []
        , button [ type_ "button", onClick NewOrUpdate ] [ text "NewOrUpdate" ]
        ]

mediafileForm : Model -> Html Msg
mediafileForm model =
    Html.form []
        [
        div [] [ text "mediaFile" ]

        , div [] [ text "File Location | checksum" ]
        , input
            [ type_ "text"
            , placeholder "FileName"
            , onInput SetMediaFileLocation
            , Html.Attributes.value model.mediaFile.fileName
            ]
            []
        , input
            [ type_ "text"
            , placeholder "Checksum"
            , onInput SetMediaFileChecksum
            , Html.Attributes.value model.mediaFile.checksum
            ]
            []
        ]

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
