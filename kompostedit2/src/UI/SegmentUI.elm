module UI.SegmentUI exposing (asStartIn, asIdIn, asCurrentSegmentIn, asEndIn, containsSegment, performSegmentOnModel, addSegmentToKomposition, segmentForm, showSegmentList)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import Models.MsgModel exposing (Config, Msg(..), Model)
import Models.KompostModels exposing (Komposition, Segment)
import RemoteData exposing (succeed)
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid


--asStartIn : Segment -> String -> Segment


asStartIn =
    flip setStart


asEndIn =
    flip setEnd


asIdIn =
    flip setId



--setStart : String -> Segment -> Segment


setStart newStart segment =
    { segment | start = (validNr newStart) }


setEnd newEnd segment =
    { segment | end = (validNr newEnd) }


setId newId segment =
    { segment | id = newId }


setCurrentSegment : Segment -> Model -> Model
setCurrentSegment newSegment model =
    { model | segment = newSegment }


asCurrentSegmentIn : Model -> Segment -> Model
asCurrentSegmentIn =
    flip setCurrentSegment


containsSegment : String -> RemoteData.WebData Komposition -> List Models.KompostModels.Segment
containsSegment id webKomposition =
    case RemoteData.toMaybe webKomposition of
        Just komposition ->
            List.filter (\seg -> seg.id == id) komposition.segments

        _ ->
            []


performSegmentOnModel segment function model  =
    case RemoteData.toMaybe model.kompost of
        Just komp ->
            { model | kompost = succeed (function segment komp) }

        _ ->
            model


addSegmentToKomposition : Segment -> Komposition -> Komposition
addSegmentToKomposition segment komposition =
    { komposition | segments = (Segment segment.id segment.start segment.end) :: komposition.segments }


deleteSegmentFromKomposition : Segment -> Komposition -> Komposition
deleteSegmentFromKomposition segment komposition =
    { komposition | segments = List.filter (\n -> n.id /= segment.id) komposition.segments }


validNr : String -> Int
validNr value =
    case String.toInt value of
        Ok int ->
            int

        Err _ ->
            -1


segmentForm : Config msg -> Bool -> Html msg
segmentForm config editableSegmentId =
    div []
        [ h1 [] [ text "Editing Segment" ]
        , Form.form [ class "container" ]
            [ Form.row [ Form.rowSuccess ]
                [ Form.colLabel [ Col.xs4 ]
                    [ text "Segment ID:" ]
                , Form.col [ Col.xs8 ]
                    [ Input.text [ Input.id "segmentId", Input.defaultValue config.segment.id, Input.onInput config.onClickSetSegmentID, Input.disabled (not editableSegmentId) ] ]
                ]
            , Form.row []
                [ Form.colLabelSm [ Col.xs4 ]
                    [ text "Start and end" ]
                , Form.col [ Col.xs4 ]
                    [ Input.number [ Input.small, Input.defaultValue (toString config.segment.start), Input.onInput config.onClickSetSegmentStart, Input.attrs [ placeholder "Start" ] ] ]
                , Form.col [ Col.xs4 ]
                    [ Input.number [ Input.small, Input.defaultValue (toString config.segment.end), Input.onInput config.onClickSetSegmentEnd, Input.attrs [ placeholder "End" ] ] ]
                ]
            , Form.row []
                [ Form.colLabel [ Col.xs4 ]
                    []
                , Form.col []
                    [ Button.button [ Button.secondary, Button.onClick config.onClickViewListings ] [ text "Back" ] ]
                , Form.col []
                    [ Button.button [ Button.primary, Button.small, Button.onClick config.onClickUpdateSegment ] [ text "Store" ] ]
                , Form.col []
                    [ Button.button [ Button.warning, Button.small, Button.onClick config.onClickDeleteSegment ] [ text "Delete" ] ]
                ]
            ]
        ]


showSegmentList : List Segment -> Config msg -> Html msg
showSegmentList segs config =
    div [] (segs |> List.map (showSingleSegment config))


showSingleSegment : Config msg -> Segment -> Html msg
showSingleSegment config segment =
    Grid.row []
        [ Grid.col [] [ Button.button [ Button.success, Button.small, Button.onClick (config.onClickEditSegment segment.id) ] [ text segment.id ] ]
        , Grid.col [] [ text <| toString segment.start ]
        , Grid.col [] [ text <| toString segment.end ]
        ]
