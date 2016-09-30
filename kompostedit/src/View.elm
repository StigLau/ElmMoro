module View exposing (..)

import Model exposing (..)
import Controller exposing (..)
import Messages exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Kompost dvl editor" ]
        , segmentSection model
        , segmentForm model
        , text "Komposition: ", text (toString model)
        ]

segmentSection : Model -> Html Msg
segmentSection model =
    div []
        [ segmentListHeader
        , segmentList model
        ]

segmentListHeader : Html Msg
segmentListHeader =
    header []
        [ div [] [ text "Id" ]
        , div [] [ text "Start" ]
        , div [] [ text "End" ]
        ]

segmentList : Model -> Html Msg
segmentList model =
    model.segments
        |> List.sortBy .start
        |> List.map segment
        |> ul []


segment : Segment -> Html Msg
segment segment =
    li [] --See Play class remove
        [ div []
            [ text segment.id, text " ",  text (toString segment.start), text " ",  text (toString segment.end) ]
            , button [ type' "button", onClick (DeleteSegment segment)] [ text "Delete" ]
        ]



segmentForm : Model -> Html Msg
segmentForm model =
    Html.form [ onSubmit Create ]
        [ input
            [ type' "text"
            , placeholder "Segment Name"
            , onInput SetSegmentName
            , value model.name
            ] []
        , input
            [ type' "number"
            , placeholder "Start"
            , onInput SetSegmentStart
            , value model.start
            ] []
        , input
            [ type' "number"
            , placeholder "End"
            , onInput SetSegmentEnd
            , value model.end
            ] []
        , button [ type' "button", onClick Save ] [ text "Save" ]
        ]


