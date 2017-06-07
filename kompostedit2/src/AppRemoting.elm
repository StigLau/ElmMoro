module AppRemoting exposing (..)

import Http exposing (emptyBody, expectJson)
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import RemoteData exposing (WebData, isLoading)
import MsgModel exposing (..)
import Models.KompostApi exposing (kompositionDecoder)


--- Decoders ---


decodeProduct : Decoder Product
decodeProduct =
    decode Product
        |> required "id" Json.Decode.string
        |> required "name" Json.Decode.string
        |> required "price" Json.Decode.float
        |> required "image" Json.Decode.string



---- Requests ----


getProducts : Cmd Msg
getProducts =
    Http.get "https://hipstore.now.sh/api/products" (Json.Decode.list decodeProduct)
        |> RemoteData.sendRequest
        |> Cmd.map ProductsChanged


getCart : Cmd Msg
getCart =
    Http.request
        { method = "get"
        , headers = []
        , url = ("https://hipstore.now.sh/api/cart")
        , body = emptyBody
        , expect = expectJson (Json.Decode.list decodeProduct)
        , timeout = Nothing
        , withCredentials = True
        }
        |> RemoteData.sendRequest
        |> Cmd.map CartChanged


addToCart : String -> Cmd Msg
addToCart id =
    Http.request
        { method = "post"
        , headers = []
        , url = ("https://hipstore.now.sh/api/cart/" ++ id)
        , body = emptyBody
        , expect = expectJson (Json.Decode.list decodeProduct)
        , timeout = Nothing
        , withCredentials = True
        }
        |> RemoteData.sendRequest
        |> Cmd.map CartChanged


removeFromCart : String -> Cmd Msg
removeFromCart id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = ("https://hipstore.now.sh/api/cart/" ++ id)
        , body = emptyBody
        , expect = expectJson (Json.Decode.list decodeProduct)
        , timeout = Nothing
        , withCredentials = True
        }
        |> RemoteData.sendRequest
        |> Cmd.map CartChanged


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
