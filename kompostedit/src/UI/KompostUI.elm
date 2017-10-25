module UI.KompostUI exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Bootstrap.Grid as Grid
import Bootstrap.Button as Button
import Bootstrap.Button exposing (onClick)
import Bootstrap.Form.Checkbox as Checkbox
import RemoteData exposing (RemoteData(..))
import Segment.SegmentUI exposing (showSegmentList)
import DvlSpecifics.DvlSpecificsUI as Specifics exposing (showSpecifics)
import Models.BaseModel exposing (Model)
import Models.Msg exposing (Msg(..))
import Models.KompostApi exposing (kompoUrl)
import Models.JsonCoding exposing (kompositionEncoder)
import Navigation.AppRouting exposing (Page(ListingsUI))


kompost : Model -> Html Models.Msg.Msg
kompost model =
    let
        (sourceText,videoCreationButton) =
            case model.showSnippets of
                False ->
                    ("Sources",
                        Button.button [ Button.primary, Button.small, Button.onClick CreateVideo ] [ text "Create Video" ])

                True ->
                    ( "Snippets",
                    Button.button [ Button.primary, Button.small, Button.onClick SplitUpToSnippets ] [ text "Split up snippets" ])

    in
        div []
            [ Grid.row []
                [ Grid.col [] [ Checkbox.checkbox [ Checkbox.onCheck FlipSnippetShowing, Checkbox.checked model.showSnippets ] sourceText ]
                , Grid.col [] []
                , Grid.col [] [ Button.button [ Button.secondary, Button.onClick (NavigateTo ListingsUI) ] [ text "List Komposti" ] ]
                ]
            , div [] [ h4 [ style [ ( "flex", "1" ) ] ] [ text model.kompost.dvlType ] ]
            , h4 [] [ text "Segments:" ]
            , Html.map SegmentMsg (Segment.SegmentUI.showSegmentList model.kompost.segments)
            , Grid.simpleRow [ Grid.col [] [ Button.button [ Button.primary, Button.small, Button.onClick CreateSegment ] [ text "New Segment" ] ] ]
            , Grid.simpleRow [ Grid.col [] [] ]
            , Specifics.showSpecifics model
            , Grid.simpleRow [ Grid.col [] [] ]
            , Grid.simpleRow
                [ Grid.col [] []
                , Grid.col [] [ Button.button [ Button.success, Button.small, Button.onClick StoreKomposition ] [ text "Store Komposition" ] ]
                , Grid.col [] [ Button.button [ Button.danger, Button.small, Button.onClick DeleteKomposition ] [ text "Delete Komposition" ] ]
                ]
            , Grid.simpleRow [ Grid.col [] [ videoCreationButton ] ]
            , Grid.simpleRow
                [ Grid.col []
                    [ Button.button [ Button.primary, Button.small, Button.onClick ShowKompositionJson ] [ text "Show JSON" ] ]
                ]
            ]


kompostJson : Model -> Html Models.Msg.Msg
kompostJson model =
    let
        kompost =
            model.kompost

        filterdSourcies =
            List.filter (\source -> model.showSnippets == source.isSnippet || source.mediaType == "audio") kompost.sources

        json =
            Models.JsonCoding.kompositionEncoder { kompost | sources = filterdSourcies } Models.KompostApi.kompoUrl
    in
        text json
