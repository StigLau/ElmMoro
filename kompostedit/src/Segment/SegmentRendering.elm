module Segment.SegmentRendering exposing (calculateSegmentGaps, gapVisualizer)

import Html exposing (Html, text)
import Html.Attributes
import Models.BaseModel exposing (Komposition, Model, Segment, SegmentGap)
import Svg exposing (..)
import Svg.Attributes exposing (..)


calculateSegmentGaps : List Segment -> List SegmentGap
calculateSegmentGaps segmentlist =
    case segmentlist of
        head :: tail ->
            quarnUnknown head tail

        alone ->
            let
                _ =
                    Debug.log "alone is " alone
            in
            [ SegmentGap "Alone" 5 -5 ]


quarnUnknown : Segment -> List Segment -> List SegmentGap
quarnUnknown head tail =
    case tail of
        second :: rest ->
            quarnTwo head second :: quarnUnknown second rest

        [] ->
            []


quarnTwo : Segment -> Segment -> SegmentGap
quarnTwo first second =
    SegmentGap (first.id ++ " " ++ second.id) first.end (abs (second.start - first.end))


gapVisualizer : Komposition -> Html msg
gapVisualizer kompost =
    svg [ viewBox "0 0 200 800", Svg.Attributes.width ("800 px") ]
        (drawSegmentGaps drawRect kompost.segments ++ drawSegmentGaps drawLegendText kompost.segments)


drawSegmentGaps : (String -> Int -> Int -> Svg msg) -> List Segment -> List (Svg msg)
drawSegmentGaps svgDrawer segmentList  =
    List.map (\segment -> svgDrawer segment.id segment.start (segment.end - segment.start - 1)) segmentList


drawRect : String -> Int -> Int -> Svg msg
drawRect text startInt widthInt =
    let
        color =
            if widthInt > 0 then
                "#023963"

            else if widthInt < 0 then
                "#0B79CE"

            else
                "#AAAAAA"

        start =
            String.fromInt startInt

        widthZ =
            String.fromInt (abs widthInt)
    in
    rect [ x "10", y start, width "10", height widthZ, fill color ] []


drawLegendText : String -> Int -> Int -> Svg msg
drawLegendText text positionX positionY =
    Svg.text_
        [ pointerEvents "none" -- prevents typing cursor (and mousedown-capture, though this is behind all other objects so that doesn't matter)
        , x (String.fromInt positionX)
        , y (String.fromInt positionY)
        , fontSize "4"
        , Html.Attributes.style "-webkit-user-select" "none"
        ]
        [ Svg.tspan [ x "20", dy "1.2em" ] [ Svg.text text ] ]


--https://github.com/oresmus/elm-examples/blob/master/svg-drag-1/svg-drag-1.elm
