module Models.KompostApi exposing (getKomposition, updateKompo, createKompo, deleteKompo, processKomposition, getDvlSegmentList, fetchETagHeader)

import Http exposing (emptyBody, expectJson)
import Models.JsonCoding exposing (..)
import RemoteData exposing (RemoteData(..))
import Models.Msg exposing (Msg(KompositionUpdated, CouchServerStatus, SegmentListUpdated, ETagResponse))
import Models.BaseModel exposing (Komposition)
import Dict


kompoUrl : String
kompoUrl =
    "http://heap.kompo.st/"

kvaernUrl = "http://localhost:4567/"

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
    let _ = Debug.log "In getDvlSegmentList " (kompoUrl ++ id)
    in Http.get (kompoUrl ++ id) kompositionDecoder
        |> RemoteData.sendRequest
        |> Cmd.map SegmentListUpdated

createKompo : Komposition -> Cmd Msg
createKompo komposition =
    Http.post kompoUrl (Http.stringBody "application/json" <| kompositionEncoder komposition kompoUrl) couchServerStatusDecoder
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus

processKomposition : Komposition -> Cmd Msg
processKomposition komposition =
    Http.request
        { base | method = "PUT"
        , url = kompoUrl ++ komposition.name
        , body = Http.stringBody "application/json" <| kompositionEncoder komposition kompoUrl
        }
      |> RemoteData.sendRequest
      |> Cmd.map CouchServerStatus

updateKompo : Komposition -> Cmd Msg
updateKompo komposition =
    Http.request
        { base | method = "PUT"
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
        Http.send ETagResponse (getHeader "ETag" (kompoUrl ++ id))


getHeader : String -> String -> Http.Request String
getHeader name url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectStringResponse (extractHeader name)
        , timeout = Nothing
        , withCredentials = False
        }


extractHeader : String -> Http.Response String -> Result String String
extractHeader name resp =
    Dict.get name resp.headers
        |> Result.fromMaybe ("header " ++ name ++ " not found")
