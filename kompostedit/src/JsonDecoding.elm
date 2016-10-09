module JsonDecoding exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Model exposing (..)

type alias JsonKomposition = { komposition : Komposition }

decodeJson : Json.Decode.Decoder JsonKomposition
decodeJson =
    decode JsonKomposition
        |> required "komposition" (decodeJsonKomposition)

decodeJsonKomposition : Json.Decode.Decoder Komposition
decodeJsonKomposition =
    decode Komposition
        |> required "mediaFile" (decodeJsonMediafile)
        |> required "segments" (Json.Decode.list decodeJsonSegment)

decodeJsonMediafile : Json.Decode.Decoder Mediafile
decodeJsonMediafile =
    decode Mediafile
        |> required "fileName" (Json.Decode.string)
        |> required "startingOffset" (Json.Decode.int)
        |> required "checksum" (Json.Decode.string)

decodeJsonSegment : Json.Decode.Decoder Segment
decodeJsonSegment =
    decode Segment
        |> required "id" (Json.Decode.string)
        |> required "start" (Json.Decode.int)
        |> required "end" (Json.Decode.int)


--Encoding
encodeKomposition : JsonKomposition -> Json.Encode.Value
encodeKomposition record = Json.Encode.object [ ("komposition",  encodeJsonKomposition <| record.komposition) ]

encodeJsonKomposition : Komposition -> Json.Encode.Value
encodeJsonKomposition record = Json.Encode.object
        [ ("mediaFile",  encodeJsonMediafile <| record.mediaFile)
        , ("segments",  Json.Encode.list <| List.map encodeSegment <| record.segments)
        ]

encodeJsonMediafile : Mediafile -> Json.Encode.Value
encodeJsonMediafile record = Json.Encode.object
        [ ("fileName",  Json.Encode.string <| record.fileName)
        , ("startingOffset",  Json.Encode.int <| record.startingOffset)
        , ("checksum",  Json.Encode.string <| record.checksum)
        ]

encodeSegment : Segment -> Json.Encode.Value
encodeSegment record = Json.Encode.object
        [ ("id",  Json.Encode.string <| record.id)
        , ("start",  Json.Encode.int <| record.start)
        , ("end",  Json.Encode.int <| record.end)
        ]