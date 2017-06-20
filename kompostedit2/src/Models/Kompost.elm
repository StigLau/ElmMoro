module Models.Kompost exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Bootstrap.Grid as Grid
import Bootstrap.Button as Button
import Bootstrap.Button exposing (onClick)
import RemoteData exposing (RemoteData(..))
import UI exposing (theme)
import MsgModel exposing (..)
import Models.KompostApi exposing (kompositionDecoder)
import Models.SegmentUI exposing (showSegmentList)
import Json.Decode as JsonD
import Json.Encode as JsonE
import Http exposing (emptyBody, expectJson)


getKomposition : String -> Cmd Msg
getKomposition id =
    Http.request
        { method = "get"
        , headers = []
        , url = ("http://heap.kompo.st/" ++ id)
        , body = emptyBody
        , expect = expectJson kompositionDecoder
        , timeout = Nothing
        , withCredentials = True
        }
        |> RemoteData.sendRequest
        |> Cmd.map KompositionUpdated


kompost : Config msg -> Html msg
kompost config =
  div
        [ style
            [ ( "display", "grid" )
            , ( "grid-template-rows", "min-content min-content 1fr min-content" )
            , ( "height", "100vh" )
            , ( "color", "#616161" )
            ]
        ]
        [ theme config.loadingIndicator
        , div
            [ style
                [ ( "display", "flex" )
                , ( "align-items", "center" )
                , ( "justify-content", "center" )
                , ( "height", "75px" )
                , ( "padding", "0 2rem" )
                ]
            ]
            [ h4 [ style [ ( "flex", "1" ) ] ] [ text "Kompost:" ]
            , Button.button [ Button.secondary, Button.onClick config.onClickViewListings ] [ text "List Komposti"]
            ]
        , kompositionView config.kompost
        , editSegmentButton config
        , Button.button [ Button.secondary, Button.onClick config.onClickViewListings ] [ text "List Komposti" ]
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
                    , Models.SegmentUI.showSegmentList kompo.segments ]
        Nothing -> text "Could not fetch komposition"

editSegmentButton: Config msg -> Html msg
editSegmentButton config =  Button.button [ Button.attrs [ style [ ( "margin-top", "auto" ) ] ]
   , Button.secondary, onClick <| (config.onClickEditSegment config.segment.id) ] [ text config.segment.id ]