module JsonDecoding exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias JsonKomposition = { komposition : Komposition }

type alias Mediafile =
    { fileName : String
    , startingOffset : Int
    , checksum : String
    , bpm : Int
    }

type alias Komposition =
    { mediaFile : Mediafile
    }

decodeJson : Json.Decode.Decoder JsonKomposition
decodeJson =
    decode JsonKomposition
        |> required "komposition" (decodeJsonKomposition)

decodeJsonKomposition : Json.Decode.Decoder Komposition
decodeJsonKomposition =
    decode Komposition
        |> required "mediaFile" (decodeJsonMediafile)

decodeJsonMediafile : Json.Decode.Decoder Mediafile
decodeJsonMediafile =
    decode Mediafile
        |> required "fileName" (Json.Decode.string)
        |> required "startingOffset" (Json.Decode.int)
        |> required "checksum" (Json.Decode.string)
        |> required "bpm" (Json.Decode.int)


encodeKomposition : JsonKomposition -> Json.Encode.Value
encodeKomposition record = Json.Encode.object [ ("komposition",  encodeJsonKomposition <| record.komposition) ]

encodeJsonKomposition : Komposition -> Json.Encode.Value
encodeJsonKomposition record = Json.Encode.object
        [ ("mediaFile",  encodeJsonMediafile <| record.mediaFile) ]

encodeJsonMediafile : Mediafile -> Json.Encode.Value
encodeJsonMediafile record = Json.Encode.object
        [ ("fileName",  Json.Encode.string <| record.fileName)
        , ("startingOffset",  Json.Encode.int <| record.startingOffset)
        , ("checksum",  Json.Encode.string <| record.checksum)
        , ("bpm",  Json.Encode.int <| record.bpm)
        ]