module Models.KompostApi exposing (getKomposition, updateKompo, createKompo, deleteKompo, getDataFromRemoteServer)

import Json.Decode as JsonD
import Json.Encode as JsonE
import Json.Decode.Pipeline as JsonDPipe
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Http exposing (emptyBody, expectJson)
import RemoteData exposing (RemoteData(..))
import Models.Msg exposing (Msg(KompositionUpdated, CouchServerStatus, DataBackFromRemoteServer))
import Models.BaseModel exposing (Komposition, Segment, Mediafile, CouchStatusMessage)


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
  Json.Decode.Pipeline.decode Komposition
    |> required "_id" JsonD.string
    |> required "_rev" JsonD.string
    |> required "bpm" JsonD.float
    |> required "mediaFile" mediaFileDecoder
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
    JsonD.map3 Mediafile
        (JsonD.field "fileName" JsonD.string)
        (JsonD.field "startingOffset" JsonD.float)
        (JsonD.field "checksum" JsonD.string)


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
            , ( "mediaFile", encodeMediaFile kompo.mediaFile )
            , ( "segments", JsonE.list <| List.map encodeSegment kompo.segments )
            ]   ++ revision ++ sources
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


getDataFromRemoteServer : String -> Cmd Msg
getDataFromRemoteServer topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

    request =
      Http.get url decodeGifUrl
  in
    Http.send DataBackFromRemoteServer request

decodeGifUrl : JsonD.Decoder String
decodeGifUrl =
  JsonD.at ["data", "image_url"] JsonD.string