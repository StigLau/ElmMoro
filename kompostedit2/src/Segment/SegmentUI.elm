module Segment.SegmentUI exposing (segmentForm, showSegmentList)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import Models.MsgModel exposing (..)
import Models.BaseModel exposing (..)
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Segment.Model exposing (Msg(..))
import Navigation.AppRouting exposing (Page(Kompost))
import Models.MsgModel exposing (Msg)


segmentForm : Model -> Bool -> Html Segment.Model.Msg
segmentForm model editableSegmentId =
    div []
        [ h1 [] [ text "Editing Segment" ]
        , Form.form [ class "container" ]
            [ Form.row [ Form.rowSuccess ]
                [ Form.colLabel [ Col.xs4 ]
                    [ text "Segment ID:" ]
                , Form.col [ Col.xs8 ]
                    [ Input.text [ Input.id "segmentId", Input.defaultValue model.segment.id, Input.onInput SetSegmentId, Input.disabled (not editableSegmentId) ] ]
                ]
            , Form.row []
                [ Form.colLabelSm [ Col.xs4 ]
                    [ text "Start and end" ]
                , Form.col [ Col.xs4 ]
                    [ Input.number [ Input.small, Input.defaultValue (toString model.segment.start), Input.onInput SetSegmentStart, Input.attrs [ placeholder "Start" ] ] ]
                , Form.col [ Col.xs4 ]
                    [ Input.number [ Input.small, Input.defaultValue (toString model.segment.end), Input.onInput SetSegmentEnd, Input.attrs [ placeholder "End" ] ] ]
                ]
            , Form.row []
                [ Form.colLabel [ Col.xs4 ]
                    []
                , Form.col []
                    [ Button.button [ Button.secondary, Button.onClick (InternalNavigateTo Kompost) ] [ text "Back" ] ]
                , Form.col []
                    [ Button.button [ Button.primary, Button.small, Button.onClick UpdateSegment ] [ text "Save" ] ]
                , Form.col []
                    [ Button.button [ Button.warning, Button.small, Button.onClick DeleteSegment ] [ text "Delete" ] ]
                ]
            ]
        ]


showSegmentList : List Segment -> Html Segment.Model.Msg
showSegmentList segs =
    div [] ((List.sortBy .start segs) |> List.map showSingleSegment)


showSingleSegment : Segment -> Html Segment.Model.Msg
showSingleSegment segment =
    Grid.row []
        [ Grid.col [] [ Button.button [ Button.secondary, Button.small, Button.onClick (EditSegment segment.id) ] [ text segment.id ] ]
        , Grid.col [] [ text <| toString segment.start ]
        , Grid.col [] [ text <| toString segment.end ]
        ]

