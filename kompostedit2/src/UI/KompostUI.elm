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
  div [ ]
        [ theme config.loadingIndicator
        , div [ ] [ h4 [ style [ ( "flex", "1" ) ] ] [ text "Kompost:" ]
            , Button.button [ Button.secondary, Button.onClick config.onClickViewListings ] [ text "List Komposti"]
            ]
        , kompositionView config.kompost
        , editSegmentButton config
        ]

kompositionView kompost =
    case RemoteData.toMaybe kompost of
        Just kompo ->
            Grid.container []
            [
                     Grid.row []
                        [ Grid.col [] [ text <| "Name: " ++ toString kompo.name ]
                        , Grid.col [] [ text <| "Revision: " ++ kompo.revision]
                        ]
                    , Grid.row []
                        [ Grid.col [] [ text "Media link" ]
                        , Grid.col [] [ text <| kompo.mediaFile.fileName ]
                        , Grid.col [] [ text <| "Checksum: " ++ kompo.mediaFile.checksum ]
                        ]
                    , UI.SegmentUI.showSegmentList kompo.segments ]
        Nothing -> text "Could not fetch komposition"

editSegmentButton: Config msg -> Html msg
editSegmentButton config =  Button.button [ Button.attrs [ style [ ( "margin-top", "auto" ) ] ]
   , Button.secondary, onClick <| (config.onClickEditSegment config.segment.id) ] [ text config.segment.id ]