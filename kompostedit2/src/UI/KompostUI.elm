module UI.KompostUI exposing (..)

import Http exposing (emptyBody, expectJson)
import Html exposing (..)
import Html.Attributes exposing (style)
import Bootstrap.Grid as Grid
import Bootstrap.Button as Button
import Bootstrap.Button exposing (onClick)
import RemoteData exposing (RemoteData(..))
import UI.Theme exposing (theme)
import UI.SegmentUI exposing (showSegmentList)
import UI.DvlSpecificsUI exposing (showSpecifics)
import Models.MsgModel exposing (Config)


kompost : Config msg -> Html msg
kompost config =
    case RemoteData.toMaybe config.kompost of
        Just kompo ->
            div []
                [ theme config.loadingIndicator
                , div [] [ h4 [ style [ ( "flex", "1" ) ] ] [ text "Kompost:" ] ]
                , UI.DvlSpecificsUI.showSpecifics kompo config
                , UI.SegmentUI.showSegmentList kompo.segments config
                , Button.button [ Button.secondary, Button.onClick config.onClickViewListings ] [ text "List Komposti" ]
                , Button.button [ Button.primary, Button.small, Button.onClick (config.onClickCreateSegment) ] [ text "New Segment" ]
                ]

        Nothing ->
            text "Could not fetch komposition"
