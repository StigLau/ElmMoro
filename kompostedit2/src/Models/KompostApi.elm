module Models.KompostApi exposing (getKomposition, updateKompo, createKompo, deleteKompo)

import Json.Decode as JsonD
import Json.Encode as JsonE
import Json.Decode.Pipeline as JsonDPipe
import Http exposing (emptyBody, expectJson)
import RemoteData exposing (RemoteData(..))
import Models.Msg exposing (Msg(KompositionUpdated, CouchServerStatus))
import Models.BaseModel exposing (Komposition, Segment, Mediafile, CouchStatusMessage)
import Json.Decode exposing (int, string, float, Decoder, nullable)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


kompoUrl : String
kompoUrl =
    "http://heap.kompo.st/"


base =
    { method = ""
    , headers = []
    , url = ""
    , body = Http.emptyBody
    , expect = Http.expectJson couchServerStatusDecoder
    , timeout = Nothing
    , withCredentials = False
    }

--getKompo : String -> (Result Http.Error Komposition -> msg) -> Cmd msg
--getKompo id msg = Http.get (kompoUrl ++ id) kompositionDecoder |> Http.send msg

getKomposition : String -> Cmd Msg
getKomposition id =
    Http.get (kompoUrl ++ id) kompositionDecoder
        |> RemoteData.sendRequest
        |> Cmd.map KompositionUpdated

createKompo : Komposition -> Cmd Msg
createKompo komposition =
    Http.post kompoUrl (Http.stringBody "application/json" <| encodeKomposition komposition) couchServerStatusDecoder
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
       JsonE.encode 0 <| JsonE.object (
            [ ( "_id", JsonE.string kompo.name )
            , ( "bpm", JsonE.float kompo.bpm)
            , ( "mediaFile", encodeMediaFile kompo.mediaFile )
            , ( "segments", JsonE.list <| List.map encodeSegment kompo.segments )
            ] ++ case kompo.revision of
                "" -> []
                revision -> [( "_rev", JsonE.string revision )]
        )


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

type alias User =
  { id : Int
  , email : Maybe String
  , name : String
  , percentExcited : Float
  }


userDecoder : Decoder User
userDecoder =
  decode User
    |> required "id" int
    |> required "email" (JsonD.maybe JsonD.string) -- `null` decodes to `Nothing`
    |> optional "name" string "(fallback if name is `null` or not present)"
    |> hardcoded 1.0


type alias Sources =
  { sources : Maybe String
  }

sourcesDecoder : Decoder Sources
sourcesDecoder =
    decode Sources
        |> required "sources" (JsonD.maybe JsonD.string)

encodeSources : Sources -> JsonE.Value
encodeSources segment =
    JsonE.object
        [ ( "id", JsonE.string segment.id )
        , ( "start", JsonE.int segment.start )
        , ( "end", JsonE.int segment.end )
        ]