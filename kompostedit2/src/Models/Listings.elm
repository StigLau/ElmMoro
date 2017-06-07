module Models.Listings exposing (getListings)

import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JsonD
import RemoteData exposing (WebData, isLoading)
import MsgModel exposing (Msg(ListingsUpdated), DataRepresentation, Row)


storeUrl : String
storeUrl = "http://heap.kompo.st/"

jsonBaseDecoder : JsonD.Decoder DataRepresentation
jsonBaseDecoder = JsonD.map3 DataRepresentation
                           (JsonD.field "total_rows" JsonD.int)
                           (JsonD.field "offset" JsonD.int)
                           (JsonD.field "rows" <| JsonD.list rowDecoder)

rowDecoder : JsonD.Decoder Row
rowDecoder = JsonD.map2 Row
                           (JsonD.field "id" JsonD.string)
                           (JsonD.field "key" JsonD.string)

getListings : Cmd MsgModel.Msg
getListings =
    Http.get (storeUrl ++ "_all_docs") jsonBaseDecoder
        |> RemoteData.sendRequest
        |> Cmd.map ListingsUpdated