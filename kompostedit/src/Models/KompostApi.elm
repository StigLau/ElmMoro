module Models.KompostApi exposing (..)

import Json.Decode as JsonD
import Json.Encode as JsonE
import Http


type alias Komposition =
  { name: String
  , start: Int
  , end: Int
  --, config: Config
  --, mediaFile: Mediafile
  , segments: List Segment
  }

type alias Segment =
  { id: String
  , start: Int
  , end: Int
  }

type alias Mediafile =
  { fileName: String
  , startingOffset: Int
  , checksum: String
  --, extension: String
  }

type alias KompositionRequest a =
    { a
        | name : String
        , start : Int
        , end : Int
        , segments : List Segment
    }


kompoUrl : String
kompoUrl = "http://localhost:8080/kompoback"

getKompo : Int -> (Result Http.Error Komposition -> msg) -> Cmd msg
getKompo id msg = Http.get (kompoUrl ++ "/no/lau/kompo?" ++ toString id) kompositionDecoder
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
            JsonD.map4 Komposition
                           (JsonD.field "name" JsonD.string)
                           (JsonD.field "start" JsonD.int)
                           (JsonD.field "end" JsonD.int)
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
        (JsonD.field "startingOffset" JsonD.int)
        (JsonD.field "checksum" JsonD.string)

encodeKomposition : KompositionRequest kompo -> String
encodeKomposition kompo =
    JsonE.encode 0 <|
        JsonE.object
            [ ( "komportistName", JsonE.string kompo.name )
            , ( "segments", JsonE.list <| List.map encodeSegment kompo.segments )
            ]

encodeSegment : Segment-> JsonE.Value
encodeSegment segment =
    JsonE.object
        [ ( "id",    JsonE.string segment.id )
        , ( "start",    JsonE.int segment.start )
        , ( "end",      JsonE.int segment.end )
        ]

