module Models.KompostApi exposing (getKomposition, updateKompo)

import Json.Decode as JsonD
import Json.Encode as JsonE
import Http exposing (emptyBody, expectJson)
import RemoteData exposing (RemoteData(..))
import Models.MsgModel exposing (Msg(KompositionUpdated, CouchServerStatus))
import Models.BaseModel exposing (Komposition, Segment, Mediafile, CouchStatusMessage)


kompoUrl : String
kompoUrl =
    "http://heap.kompo.st/"



--getKompo : String -> (Result Http.Error Komposition -> msg) -> Cmd msg
--getKompo id msg = Http.get (kompoUrl ++ id) kompositionDecoder |> Http.send msg


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


updateKompo : Komposition -> Cmd Msg
updateKompo komposition =
    Http.request
        { method = "PUT"
        , headers = []
        , url = kompoUrl ++ komposition.name
        , body = Http.stringBody "application/json" <| encodeKomposition komposition
        , expect = Http.expectJson couchServerStatusDecoder
        , timeout = Nothing
        , withCredentials = False
        }
        |> RemoteData.sendRequest
        |> Cmd.map CouchServerStatus

kompositionDecoder : JsonD.Decoder Komposition
kompositionDecoder =
    JsonD.map5 Komposition
        (JsonD.field "_id" JsonD.string)
        (JsonD.field "_rev" JsonD.string)
        (JsonD.field "bpm" JsonD.float)
        (JsonD.field "mediaFile" mediaFileDecoder)
        (JsonD.field "segments" <| JsonD.list segmentDecoder)


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
    JsonD.map3 Mediafile
        (JsonD.field "fileName" JsonD.string)
        (JsonD.field "startingOffset" JsonD.float)
        (JsonD.field "checksum" JsonD.string)


encodeKomposition : Komposition -> String
encodeKomposition kompo =
    JsonE.encode 0 <|
        JsonE.object
            [ ( "_id", JsonE.string kompo.name )
            , ( "_rev", JsonE.string kompo.revision )
            , ( "bpm", JsonE.float kompo.bpm)
            , ( "mediaFile", encodeMediaFile kompo.mediaFile )
            , ( "segments", JsonE.list <| List.map encodeSegment kompo.segments )
            ]


encodeMediaFile : Mediafile -> JsonE.Value
encodeMediaFile mediaFile =
    JsonE.object
        [ ( "fileName", JsonE.string mediaFile.fileName )
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
