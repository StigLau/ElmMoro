module Models.KompostApi exposing (kompoUrl, getKomposition, updateKompo, createKompo, deleteKompo, splitUpSnippets, createVideo, getDvlSegmentList, fetchETagHeader, kompostJson, fetchKompositionList)

import Http exposing (emptyBody, expectJson, header)
import Models.JsonCoding exposing (..)
import RemoteData exposing (RemoteData(..))
import Models.Msg exposing (Msg(KompositionUpdated, CouchServerStatus, SegmentListUpdated, SnippetSplitterResponse, ETagResponse, ListingsUpdated))
import Models.BaseModel exposing (Komposition)
import Dict
import MD5 exposing (hex)


kompoUrl : String
kompoUrl =
    "https://e82fe3cb-c41e-4b17-b0d1-a5f3d0bcb833-bluemix.cloudant.com/kompost/"


kvaernUrl =
    "http://localhost:3000"

autHeaders = [ (Http.header "Authorization" "Basic aHJpb25zaW9uZXNzaWNlcHJlZGlkc3RyOjE4NWQ4MDgyMzE0MGY4Yzg0NDk5YTU3OTkxNGNkZDZhNTIzYjM5ZjA=")]

base =
    { method = ""
    , headers = autHeaders
    , url = ""
    , body = Http.emptyBody
    , expect = Http.expectJson couchServerStatusDecoder
    , timeout = Nothing
    , withCredentials = False
    }

snuppet =
    { method = ""
    , headers = autHeaders
    , url = ""
    , body = Http.emptyBody
    , expect = Http.expectJson kompositionDecoder
    , timeout = Nothing
    , withCredentials = False
    }

fetchKompositionList : String ->  Cmd Msg
fetchKompositionList typeIdentifier =
    Http.request
            { base
                | method = "POST"
                , url = kompoUrl ++ "_find"
                , body = Http.stringBody "application/json" (searchEncoder typeIdentifier)

                , expect = Http.expectJson kompositionListDecoder
            }
        |> RemoteData.sendRequest
        |> Cmd.map ListingsUpdated

getKomposition : String -> Cmd Msg
getKomposition id =
    Http.request
            { base
                | method = "GET"
                , headers = autHeaders
                , url = kompoUrl ++ id
                , expect = Http.expectJson kompositionDecoder
            }
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
        { snuppet
            | method = "POST"
            , url = kvaernUrl ++ "/kvaern/snippetsplitter?" ++ komposition.name
            , body = Http.stringBody "application/json" <| kompostJson komposition
        }
        |> RemoteData.sendRequest
        |> Cmd.map SnippetSplitterResponse


createVideo : Komposition -> Cmd Msg
createVideo komposition =
    Http.request
        { base
            | method = "POST"
            , url = kvaernUrl ++ "/kvaern/createvideo?" ++ komposition.name
            , body = Http.stringBody "application/json" <| kompostJson komposition
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
            , body = Http.stringBody "application/json" <| kompositionEncoder komposition kompoUrl
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
    Http.send ETagResponse (getHeader "etag" (kompoUrl ++ id))


getHeader : String -> String -> Http.Request String
getHeader name url =
    Http.request
        { method = "GET"
        , headers = autHeaders
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


stripHyphens input = --Remove '/"' --> devowel = replace All (regex "[aeiou]") (\_ -> "")
    input
        |> String.dropRight 1
        |> String.dropLeft 1


kompostJson : Komposition -> String
kompostJson kompost =
        kompositionEncoder { kompost | sources = kompost.sources } kompoUrl
