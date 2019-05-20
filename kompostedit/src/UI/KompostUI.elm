module UI.KompostUI exposing (kompost)

import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import DvlSpecifics.DvlSpecificsUI as Specifics
import Html exposing (..)
import Html.Attributes exposing (style)
import Models.BaseModel exposing (Model)
import Models.Msg exposing (Msg(..))
import Navigation.Page as Page exposing (Page)
import Segment.SegmentRendering exposing (gapVisualizer)
import Segment.SegmentUI
import Source.View exposing (editSources, sourceNewButton)


kompost : Model -> Html Models.Msg.Msg
kompost model =
    div []
        [ Grid.row []
            [ Grid.col [] []
            , Grid.col [] [ Button.button [ Button.secondary, Button.onClick (NavigateTo Page.ListingsUI) ] [ text "List Komposti" ] ]
            ]
        , div [] [ h4 [ style "flex" "1" ] [ text model.kompost.dvlType ] ]
        , Specifics.showSpecifics model
        , h4 [] [ text "Original Sources:" ]
        , editSources model.kompost.sources
        , sourceNewButton
        , Grid.simpleRow [ Grid.col [] [] ]
        , h4 [] [ text "Segments:" ]
        , Html.map SegmentMsg (Segment.SegmentUI.showSegmentList model.kompost.segments)
        , Grid.simpleRow [ Grid.col [] [ Button.button [ Button.primary, Button.small, Button.onClick CreateSegment ] [ text "New Segment" ] ] ]
        , Grid.simpleRow [ Grid.col [] [] ]
        , Grid.simpleRow
            [ Grid.col [] []
            , Grid.col [] [ Button.button [ Button.success, Button.small, Button.onClick StoreKomposition ] [ text "Store Komposition" ] ]
            , Grid.col [] [ Button.button [ Button.danger, Button.small, Button.onClick DeleteKomposition ] [ text "Delete Komposition" ] ]
            ]
        , Grid.simpleRow [ Grid.col [] [ Button.button [ Button.primary, Button.small, Button.onClick CreateVideo ] [ text "Create Video" ] ] ]
        , Grid.simpleRow
            [ Grid.col []
                [ Button.button [ Button.primary, Button.small, Button.onClick ShowKompositionJson ] [ text "Show JSON" ] ]
            ]
        , h4 [] [ text "Segments view:" ]
        , gapVisualizer model.kompost
        ]
