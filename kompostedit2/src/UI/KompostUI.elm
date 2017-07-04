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
    div []
        [ div [] [ h4 [ style [ ( "flex", "1" ) ] ] [ text "Kompost:" ] ]
        , UI.DvlSpecificsUI.showSpecifics config.kompost  config
        , UI.SegmentUI.showSegmentList config.kompost.segments config
        , Button.button [ Button.secondary, Button.onClick config.onClickViewListings ] [ text "List Komposti" ]
        , Button.button [ Button.primary, Button.small, Button.onClick (config.onClickCreateSegment) ] [ text "New Segment" ]
        , Button.button [ Button.success, Button.small, Button.onClick (config.onClickStoreKomposition) ] [ text "Store Komposition" ]
        ]