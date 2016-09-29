module View exposing (..)

import Model exposing (..)
import Controller exposing (..)
import Messages exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import Maybe exposing (..)


view : DvlKomposition -> Html Msg
view komposition =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Kompost dvl editor" ]
        , segmentSection komposition
        , segmentForm komposition
        , text "Komposition: ", text (toString komposition)

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
        [ button [ type' "button", onClick Create ] [ text "Create" ]

        , div []
            [ text segment.id, text " ",  text (toString segment.start), text " ",  text (toString segment.end) ]
        ]



segmentForm : DvlKomposition -> Html Msg
segmentForm komposition =
    Html.form [ onSubmit Create ]
        [ input
            [ type' "text"
            , placeholder "Add/Edit Player..."
            , onInput Input
            , value komposition.reference
            ]
            []
        , button [ type' "submit" ] [ text "Save" ]
--        , button [ type' "button", onClick Cancel ] [ text "Cancel" ]
        ]


