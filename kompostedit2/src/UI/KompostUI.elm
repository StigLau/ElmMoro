module UI.KompostUI exposing (..)

import Http exposing (emptyBody, expectJson)
import Html exposing (..)
import Html.Attributes exposing (style)
import Bootstrap.Grid as Grid
import Bootstrap.Button as Button
import Bootstrap.Button exposing (onClick)
import RemoteData exposing (RemoteData(..))
import Segment.SegmentUI exposing (showSegmentList)
import UI.DvlSpecificsUI exposing (showSpecifics)
import Models.BaseModel exposing (Model)
import Models.Msg exposing (Msg(..))
import Navigation.AppRouting exposing (Page(ListingsUI))


kompost : Model -> Html Models.Msg.Msg
kompost model =
    div []
        [ Grid.row [] [ Grid.col [] [] , Grid.col [] [], Grid.col [] [Button.button [ Button.secondary, Button.onClick (NavigateTo ListingsUI) ] [ text "List Komposti" ]]]
        , div [] [ h4 [ style [ ( "flex", "1" ) ] ] [ text "Kompost:" ] ]
        , UI.DvlSpecificsUI.showSpecifics model.kompost
        , h4 []  [ text "Segments:" ]
        , Html.map SegmentMsg(Segment.SegmentUI.showSegmentList model.kompost.segments)
        , Grid.simpleRow [ Grid.col [] [Button.button [ Button.primary, Button.small, Button.onClick CreateSegment ] [ text "New Segment" ]]]
        , Grid.simpleRow
            [ Grid.col [] []
            , Grid.col [] [Button.button [ Button.success, Button.small, Button.onClick StoreKomposition ] [ text "Store Komposition" ]]
            , Grid.col [] [Button.button [ Button.danger, Button.small, Button.onClick DeleteKomposition ] [ text "Delete Komposition" ]]
            ]
        , Grid.simpleRow [ Grid.col [] [Button.button [ Button.primary, Button.small, Button.onClick OrderKompositionProcessing ] [ text "Create Video" ]]]
        , Grid.simpleRow [Grid.col [] [text ("Status: " ++ toString model.statusMessage)]]
        ]