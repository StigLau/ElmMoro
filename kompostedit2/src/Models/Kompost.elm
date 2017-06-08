module Models.Kompost exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Button exposing (onClick)
import RemoteData exposing (RemoteData(..))
import UI exposing (theme)
import MsgModel exposing (..)
import Json.Decode as JsonD
import Json.Encode as JsonE
import Http exposing (emptyBody, expectJson)
import Models.KompostApi exposing (kompositionDecoder)



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
            , Bootstrap.Button.button
                [ Bootstrap.Button.secondary
                , Bootstrap.Button.onClick config.onClickViewListings
                ]
                [ text "List Komposti"
                ]
            ]
        , div
                [ style
                  [ ( "display", "flex" )
                  , ( "align-items", "center" )
                  , ( "justify-content", "flex-end" )
                  , ( "height", "75px" )
                  , ( "padding", "0 2rem" )
                  ]
                ]
                [ span []
                  [ text "Total: "
                  , case RemoteData.toMaybe config.kompost of
                      Just kompost ->
                              text <| (toString kompost) ++ "\x1F32E"

                      Nothing ->
                          text "loading or something."
                  ]
                ]
            ]

