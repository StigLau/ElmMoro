module JsonDecoding exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias Komposition = { komposition : JsonKomposition }

type alias JsonMediafile =
    { fileName : String
    , startingOffset : Int
    , checksum : String
    , bpm : Int
    }

type alias JsonKomposition =
    { mediaFile : JsonMediafile
    }

decodeJson : Json.Decode.Decoder Komposition
decodeJson =
    decode Komposition
        |> required "komposition" (decodeJsonKomposition)

decodeJsonKomposition : Json.Decode.Decoder JsonKomposition
decodeJsonKomposition =
    decode JsonKomposition
        |> required "mediaFile" (decodeJsonMediafile)

decodeJsonMediafile : Json.Decode.Decoder JsonMediafile
decodeJsonMediafile =
    decode JsonMediafile
        |> required "fileName" (Json.Decode.string)
        |> required "startingOffset" (Json.Decode.int)
        |> required "checksum" (Json.Decode.string)
        |> required "bpm" (Json.Decode.int)


encodeKomposition : Komposition -> Json.Encode.Value
encodeKomposition record = Json.Encode.object [ ("komposition",  encodeJsonKomposition <| record.komposition) ]

encodeJsonKomposition : JsonKomposition -> Json.Encode.Value
encodeJsonKomposition record = Json.Encode.object
        [ ("mediaFile",  encodeJsonMediafile <| record.mediaFile) ]

encodeJsonMediafile : JsonMediafile -> Json.Encode.Value
encodeJsonMediafile record = Json.Encode.object
        [ ("fileName",  Json.Encode.string <| record.fileName)
        , ("startingOffset",  Json.Encode.int <| record.startingOffset)
        , ("checksum",  Json.Encode.string <| record.checksum)
        , ("bpm",  Json.Encode.int <| record.bpm)
        ]