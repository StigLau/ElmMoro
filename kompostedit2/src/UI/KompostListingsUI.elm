module UI.KompostListingsUI exposing (getListings, listings)

import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Http
import Json.Decode as JsonD
import RemoteData exposing (WebData, isLoading)
import Bootstrap.Button exposing (onClick)
import Bootstrap.CDN
import Html.Attributes exposing (style)
import Models.MsgModel exposing (Config, Msg(ListingsUpdated))
import Models.BaseModel exposing (DataRepresentation, Row)
import UI.Theme exposing (theme)


storeUrl : String
storeUrl =
    "http://heap.kompo.st/"


jsonBaseDecoder : JsonD.Decoder DataRepresentation
jsonBaseDecoder =
    JsonD.map3 DataRepresentation
        (JsonD.field "total_rows" JsonD.int)
        (JsonD.field "offset" JsonD.int)
        (JsonD.field "rows" <| JsonD.list rowDecoder)


rowDecoder : JsonD.Decoder Row
rowDecoder =
    JsonD.map2 Row
        (JsonD.field "id" JsonD.string)
        (JsonD.field "key" JsonD.string)


getListings : Cmd Msg
getListings =
    Http.get (storeUrl ++ "_all_docs") jsonBaseDecoder
        |> RemoteData.sendRequest
        |> Cmd.map ListingsUpdated


listings : Config msg -> Html msg
listings config =
    div [ class "listings" ]
        [ theme config.loadingIndicator
        , h1 [] [ text ("Dvls in ") ]
        , table [ class "table table-striped" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , case RemoteData.toMaybe config.listings of
                        Just listings ->
                            tbody [] (List.map (chooseDvlButton config) listings.rows)

                        Nothing ->
                            text "loading."
                    ]
                ]
            ]
        ]


chooseDvlButton : Config msg -> Row -> Html msg
chooseDvlButton config row =
    Bootstrap.Button.button
        [ Bootstrap.Button.attrs [ style [ ( "margin-top", "auto" ) ] ]
        , Bootstrap.Button.secondary
        , onClick <| (config.onClickChooseDvl row.id)
        ]
        [ text row.id ]
