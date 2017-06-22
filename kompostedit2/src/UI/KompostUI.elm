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
import Models.MsgModel exposing (Config)


kompost : Config msg -> Html msg
kompost config =
    case RemoteData.toMaybe config.kompost of
        Just kompo ->
            div []
                [ theme config.loadingIndicator
                , div [] [ h4 [ style [ ( "flex", "1" ) ] ] [ text "Kompost:" ] ]
                , Grid.container []
                    [ addRow "Name" (text kompo.name)
                    , addRow "Revision" (text kompo.revision)
                    , addRow "Media link" (a [ Html.Attributes.href kompo.mediaFile.fileName ] [ text kompo.mediaFile.fileName ])
                    , addRow "Checksum" (text kompo.mediaFile.checksum)
                    ]
                , UI.SegmentUI.showSegmentList kompo.segments config
                , Button.button [ Button.secondary, Button.onClick config.onClickViewListings ] [ text "List Komposti" ]
                ]

        Nothing ->
            text "Could not fetch komposition"


addRow title htmlIsh =
    Grid.row []
        [ Grid.col [] [ text title ]
        , Grid.col [] [ htmlIsh ]
        ]
