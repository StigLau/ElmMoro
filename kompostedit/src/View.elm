module View exposing (..)

import Model exposing (..)
--import Controller exposing (..)
import Messages exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : DvlKomposition -> Html Msg
view komposition =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Kompost dvl editor" ]
        , segmentSection komposition
        ]

-- Bytter ut player med segment
segmentSection : DvlKomposition -> Html Msg
segmentSection komposition =
    div []
        [ segmentListHeader
        , segmentList komposition
        ]

segmentListHeader : Html Msg
segmentListHeader =
    header []
        [ div [] [ text "Id" ]
        , div [] [ text "Start" ]
        , div [] [ text "End" ]
        ]

segmentList : DvlKomposition -> Html Msg
segmentList komposition =
    komposition.segments
        |> List.sortBy .start
        |> List.map segment
        |> ul []


segment : Segment -> Html Msg
segment segment =
    li []
        [ i
            [ class "edit"
--            , onClick (Edit segment)
            ]
            []
        , div []
            [ text segment.id, text " ",  text (toString segment.start), text " ",  text (toString segment.end) ]
        ]
