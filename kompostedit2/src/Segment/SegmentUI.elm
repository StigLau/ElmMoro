module Segment.SegmentUI exposing (segmentForm, showSegmentList)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder, for)
import Html.Events exposing (onInput, onClick)
import Models.BaseModel exposing (..)
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Form.Select as Select
import Segment.Model exposing (Msg(..))
import Navigation.AppRouting exposing (Page(KompostUI))
import Models.Msg exposing (Msg)
import Common.UIFunctions exposing (selectItems)
import Set exposing (Set)

segmentForm : Model -> Bool -> Html Segment.Model.Msg
segmentForm model editableSegmentId =
    div []
        [ h1 [] [ text "Editing Segment" ]
        , Form.form [ class "container" ]
            [ Form.label [ for "segmentId" ] [ text "Segment ID" ]
                , Select.select [ Select.id "segmentId", Select.onInput SetSegmentId ]
                (selectItems model.segment.id (Set.toList model.subSegmentList))
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
                    [ Button.button [ Button.primary, Button.small, Button.onClick UpdateSegment ] [ text "Save" ] ]
                , Form.col []
                    [  ]
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

