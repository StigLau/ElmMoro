module Models.KompostApi exposing (getKomposition, updateKompo, createKompo, deleteKompo, processKomposition, getDvlSegmentList, fetchETagHeader)

import Json.Decode as JsonD
import Json.Encode as JsonE
import Json.Decode.Pipeline as JsonDPipe
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Http exposing (emptyBody, expectJson)
import RemoteData exposing (RemoteData(..))
import Models.Msg exposing (Msg(KompositionUpdated, CouchServerStatus, SegmentListUpdated, ETagResponse))
import Models.BaseModel exposing (Komposition, Segment, Mediafile, CouchStatusMessage)
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
    Http.post kompoUrl (Http.stringBody "application/json" <| encodeKomposition komposition) couchServerStatusDecoder
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus

processKomposition : Komposition -> Cmd Msg
processKomposition komposition =
    Http.request
        { base | method = "PUT"
        , url = kompoUrl ++ komposition.name
        , body = Http.stringBody "application/json" <| encodeKomposition komposition
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus

updateKompo : Komposition -> Cmd Msg
updateKompo komposition =
    Http.request
        { base | method = "PUT"
        , url = kompoUrl ++ komposition.name
        , body = Http.stringBody "application/json" <| encodeKomposition komposition
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

kompositionDecoder : JsonD.Decoder Komposition
kompositionDecoder =
  Json.Decode.Pipeline.decode Komposition
    |> required "_id" JsonD.string
    |> required "_rev" JsonD.string
    |> required "bpm" JsonD.float
    |> required "segments" (JsonD.list segmentDecoder)
    |> optional "sources" (JsonD.list mediaFileDecoder) []


couchServerStatusDecoder : JsonD.Decoder CouchStatusMessage
couchServerStatusDecoder =
    JsonD.map3 CouchStatusMessage
        (JsonD.field "id" JsonD.string)
        (JsonD.field "ok" JsonD.bool)
        (JsonD.field "rev" JsonD.string)

segmentDecoder : JsonD.Decoder Segment
segmentDecoder =
    JsonD.map3 Segment
        (JsonD.field "id" JsonD.string)
        (JsonD.field "start" JsonD.int)
        (JsonD.field "end" JsonD.int)

mediaFileDecoder : JsonD.Decoder Mediafile
mediaFileDecoder =
  Json.Decode.Pipeline.decode Mediafile
    |> required "id" JsonD.string
    |> optional "url" JsonD.string ""
    |> optional "startingOffset" JsonD.float 0
    |> optional "checksum" JsonD.string ""


encodeKomposition : Komposition -> String
encodeKomposition kompo =
    let
        revision = case kompo.revision of
               "" -> []
               revision -> [( "_rev", JsonE.string revision )]
        sources = case kompo.sources of
             [] -> [( "sources", JsonE.list <| List.map encodeMediaFile kompo.sources)]
             _ -> [( "sources", JsonE.list <| List.map encodeMediaFile kompo.sources)]
     in
       JsonE.encode 0 <| JsonE.object (
            [ ( "_id", JsonE.string kompo.name )
            , ( "bpm", JsonE.float kompo.bpm)
            , ( "segments", JsonE.list <| List.map encodeSegment kompo.segments )
            ]   ++ revision ++ sources
        )


encodeMediaFile : Mediafile -> JsonE.Value
encodeMediaFile mediaFile =
    let url = case mediaFile.url of
            "" -> (kompoUrl ++ mediaFile.id)
            url -> url
    in JsonE.object
        [ ( "id", JsonE.string mediaFile.id )
        , ( "url", JsonE.string url )
        , ( "startingOffset", JsonE.float mediaFile.startingOffset )
        , ( "checksum", JsonE.string mediaFile.checksum )
        ]


encodeSegment : Segment -> JsonE.Value
encodeSegment segment =
    JsonE.object
        [ ( "id", JsonE.string segment.id )
        , ( "start", JsonE.int segment.start )
        , ( "end", JsonE.int segment.end )
        ]

encodeSources : List String -> JsonE.Value
encodeSources sources =
    JsonE.object
    [
    ( "source", JsonE.list <| List.map encodeSource sources )
    ]

encodeSource : String -> JsonE.Value
encodeSource source =
    JsonE.object
        [ ( "source", JsonE.string source )
        ]


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
