module Models.KompostApi exposing (createKompo, createVideo, deleteKompo, fetchETagHeader, fetchKompositionList, getDvlSegmentList, getKomposition, kompoUrl, updateKompo)

import Dict
import Http
import MD5
import Models.BaseModel exposing (Komposition)
import Models.JsonCoding exposing (..)
import Models.Msg exposing (Msg(..))
import RemoteData exposing (RemoteData(..))


kompoUrl : String
kompoUrl =
    "http://localhost:8001/kompost/"


kvaernUrl =
    "http://localhost:8001/kvaern/"

autHeaders = []

base =
    { method = ""
    , headers = autHeaders
    , url = ""
    , body = Http.emptyBody
    , expect = Http.expectJson couchServerStatusDecoder
    , timeout = Nothing
    , withCredentials = False
    }

fetchKompositionList : String -> Cmd Msg
fetchKompositionList typeIdentifier =
    Http.request
        { method = "POST"
        , headers = autHeaders
        , url = kompoUrl ++ "_find"
        , body = Http.stringBody "application/json" (searchEncoder typeIdentifier)
        , expect = Http.expectJson kompositionListDecoder
        , timeout = Nothing
        , withCredentials = False
        }
        |> RemoteData.sendRequest
        |> Cmd.map ListingsUpdated


getKomposition : String -> Cmd Msg
getKomposition id =
    Http.request
        { method = "GET"
        , headers = autHeaders
        , url = kompoUrl ++ id
        , body = Http.emptyBody
        , expect = Http.expectJson kompositionDecoder
        , timeout = Nothing
        , withCredentials = False
        }
        |> RemoteData.sendRequest
        |> Cmd.map KompositionUpdated


getDvlSegmentList : String -> Cmd Msg
getDvlSegmentList id =
    let
        _ =
            Debug.log "getDvlSegmentList" (kompoUrl ++ id)
    in
    Http.get (kompoUrl ++ id) kompositionDecoder
        |> RemoteData.sendRequest
        |> Cmd.map SegmentListUpdated


createKompo : Komposition -> Cmd Msg
createKompo komposition =
    Http.post kompoUrl (Http.stringBody "application/json" <| kompositionEncoder komposition) couchServerStatusDecoder
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus


createVideo : Komposition -> Cmd Msg
createVideo komposition =
    Http.request
        { base
            | method = "POST"
            , url = kvaernUrl ++ "/kvaern/createvideo?" ++ komposition.name
            , body = Http.stringBody "application/json" <| kompositionEncoder komposition
        }
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus


updateKompo : Komposition -> Cmd Msg
updateKompo komposition =
    Http.request
        { base
            | method = "PUT"
            , headers = autHeaders
            , url = kompoUrl ++ komposition.name
            , body = Http.stringBody "application/json" <| kompositionEncoder komposition
        }
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus


deleteKompo : Komposition -> Cmd Msg
deleteKompo komposition =
    Http.request
        { base
            | method = "DELETE"
            , headers = autHeaders
            , url = kompoUrl ++ komposition.name ++ "?rev=" ++ komposition.revision
        }
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus


fetchETagHeader : String -> Cmd Msg
fetchETagHeader id =
    Http.send ETagResponse (getHeader "etag" id)


getHeader : String -> String -> Http.Request String
getHeader name urlId =
    Http.request
        { method = "GET"
        , headers = autHeaders
        , url = kompoUrl ++ urlId
        , body = Http.emptyBody
        , expect = Http.expectStringResponse (extractEtagAndChecksum name)
        , timeout = Nothing
        , withCredentials = False
        }


extractEtagAndChecksum : String -> Http.Response String -> Result String String
extractEtagAndChecksum name resp =
    case Result.fromMaybe ("header " ++ name ++ " not found") (Dict.get name resp.headers) of
        Result.Ok etag ->
            Result.Ok (stripHyphens etag ++ "," ++ MD5.hex resp.body)

        Result.Err error ->
            Result.Err error


stripHyphens input =
    --Remove '/"' --> devowel = replace All (regex "[aeiou]") (\_ -> "")
    input
        |> String.dropRight 1
        |> String.dropLeft 1