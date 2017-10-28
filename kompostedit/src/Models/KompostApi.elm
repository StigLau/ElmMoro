module Models.KompostApi exposing (kompoUrl, getKomposition, updateKompo, createKompo, deleteKompo, splitUpSnippets, createVideo, getDvlSegmentList, fetchETagHeader, kompostJson)

import Http exposing (emptyBody, expectJson)
import Models.JsonCoding exposing (..)
import RemoteData exposing (RemoteData(..))
import Models.Msg exposing (Msg(KompositionUpdated, CouchServerStatus, SegmentListUpdated, ETagResponse))
import Models.BaseModel exposing (Komposition)
import Dict
import MD5 exposing (hex)


kompoUrl : String
kompoUrl =
    "http://heap.kompo.st/"


kvaernUrl =
    "http://localhost:4567/"


base =
    { method = ""
    , headers = []
    , url = ""
    , body = Http.emptyBody
    , expect = Http.expectJson couchServerStatusDecoder
    , timeout = Nothing
    , withCredentials = False
    }


getKomposition : String -> Cmd Msg
getKomposition id =
    Http.get (kompoUrl ++ id) kompositionDecoder
        |> RemoteData.sendRequest
        |> Cmd.map KompositionUpdated


getDvlSegmentList : String -> Cmd Msg
getDvlSegmentList id =
    let
        _ =
            Debug.log "In getDvlSegmentList " (kompoUrl ++ id)
    in
        Http.get (kompoUrl ++ id) kompositionDecoder
            |> RemoteData.sendRequest
            |> Cmd.map SegmentListUpdated


createKompo : Komposition -> Cmd Msg
createKompo komposition =
    Http.post kompoUrl (Http.stringBody "application/json" <| kompositionEncoder komposition kompoUrl) couchServerStatusDecoder
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus


splitUpSnippets : Komposition -> Cmd Msg
splitUpSnippets komposition =
    Http.request
        { base
            | method = "POST"
            , url = "http://localhost:3000/kvaern/snippetsplitter?" ++ komposition.name
            , body = Http.stringBody "application/json" <| kompostJson komposition False
        }
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus

createVideo : Komposition -> Cmd Msg
createVideo komposition =
    Http.request
        { base
            | method = "POST"
            , url = "http://localhost:3000/kvaern/createvideo?" ++ komposition.name
            , body = Http.stringBody "application/json" <| kompostJson komposition True
        }
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus


updateKompo : Komposition -> Cmd Msg
updateKompo komposition =
    Http.request
        { base
            | method = "PUT"
            , url = kompoUrl ++ komposition.name
            , body = Http.stringBody "application/json" <| kompositionEncoder komposition kompoUrl
        }
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus


deleteKompo : Komposition -> Cmd Msg
deleteKompo komposition =
    Http.request
        { base
            | method = "DELETE"
            , url = kompoUrl ++ komposition.name ++ "?rev=" ++ komposition.revision
        }
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus


fetchETagHeader : String -> Cmd Msg
fetchETagHeader id =
    Http.send ETagResponse (getHeader "etag" (kompoUrl ++ id))


getHeader : String -> String -> Http.Request String
getHeader name url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectStringResponse (extractEtagAndChecksum name)
        , timeout = Nothing
        , withCredentials = False
        }


extractEtagAndChecksum : String -> Http.Response String -> Result String String
extractEtagAndChecksum name resp =
    case Result.fromMaybe ("header " ++ name ++ " not found") (Dict.get name resp.headers) of
        Result.Ok etag ->
            Result.Ok (stripHyphens etag ++ "," ++ (MD5.hex resp.body))

        Result.Err error ->
            Result.Err error


stripHyphens input =
    input
        |> String.dropRight 1
        |> String.dropLeft 1


kompostJson : Komposition -> Bool ->  String
kompostJson kompost showSnippets =
    let
        filterdSourcies =
            List.filter (\source -> showSnippets == source.isSnippet || source.mediaType == "audio") kompost.sources
    in

            kompositionEncoder { kompost | sources = filterdSourcies } kompoUrl