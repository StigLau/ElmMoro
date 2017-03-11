module Models.KompostApi exposing (..)

import Json.Decode as JsonD
import Json.Encode as JsonE
import Http


type alias Komposition =
  { name: String
  --, config: Config
  , mediaFile: Mediafile
  , segments: List Segment
  }

type alias Segment =
  { id: String
  , start: Int
  , end: Int
  }

type alias Mediafile =
  { fileName: String
  , startingOffset: Float
  , checksum: String
  --, extension: String
  }

type alias KompositionRequest a =
    { a
        | name : String
        , mediaFile : Mediafile
        , segments : List Segment
    }


kompoUrl : String
kompoUrl = "http://heap.kompo.st/"

getKompo : String -> (Result Http.Error Komposition -> msg) -> Cmd msg
getKompo id msg = Http.get (kompoUrl ++ id) kompositionDecoder
        |> Http.send msg

updateKompo: Komposition -> (Result Http.Error Komposition -> msg) -> Cmd msg
updateKompo komposition msg =
    Http.request
        { method = "POST"
        , headers = []
        , url = kompoUrl ++ "/no/lau/kompo" --?" ++ toString komposition.name
        , body = Http.stringBody "application/json" <| encodeKomposition komposition
        , expect = Http.expectJson kompositionDecoder
        , timeout = Nothing
        , withCredentials = False
        }
        |> Http.send msg


kompositionDecoder : JsonD.Decoder Komposition
kompositionDecoder =
            JsonD.map3 Komposition
                           (JsonD.field "reference" JsonD.string)
                           (JsonD.field "mediaFile" mediaFileDecoder)
                           (JsonD.field "segments" <| JsonD.list segmentDecoder)
                -- _ = Debug.log "testing out stuff" komp

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

encodeKomposition : KompositionRequest kompo -> String
encodeKomposition kompo =
    JsonE.encode 0 <|
        JsonE.object
            [ ( "name", JsonE.string kompo.name )
            , ( "mediaFile", encodeMediaFile kompo.mediaFile )
            , ( "segments", JsonE.list <| List.map encodeSegment kompo.segments )
            ]

encodeMediaFile : Mediafile -> JsonE.Value
encodeMediaFile mediaFile =
    JsonE.object
        [ ( "fileName",    JsonE.string mediaFile.fileName )
        , ( "startingOffset",    JsonE.float mediaFile.startingOffset )
        , ( "checksum",      JsonE.string mediaFile.checksum )
        ]

encodeSegment : Segment-> JsonE.Value
encodeSegment segment =
    JsonE.object
        [ ( "id",    JsonE.string segment.id )
        , ( "start",    JsonE.int segment.start )
        , ( "end",      JsonE.int segment.end )
        ]

