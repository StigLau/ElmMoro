module JsonDecoding exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Model exposing (..)

type alias JsonKomposition = { komposition : Model }

decodeJson : Json.Decode.Decoder JsonKomposition
decodeJson =
    decode JsonKomposition
        |> required "komposition"       (decodeJsonKomposition)

decodeJsonKomposition : Json.Decode.Decoder Model
decodeJsonKomposition =
    decode Model
        |> required "name"              (Json.Decode.string)
        |> required "start"             (Json.Decode.string)
        |> required "end"               (Json.Decode.string)
        |> required "config"            (decodeJsonConfig)
        |> required "mediaFile"         (decodeJsonMediafile)
        |> required "segments"          (Json.Decode.list decodeJsonSegment)

decodeJsonConfig : Json.Decode.Decoder Config
decodeJsonConfig =
    decode Config
        |> required "width"             (Json.Decode.int)
        |> required "height"            (Json.Decode.int)
        |> required "framerate"         (Json.Decode.int)
        |> required "extensionType"     (Json.Decode.string)
        |> required "duration"          (Json.Decode.int)


decodeJsonMediafile : Json.Decode.Decoder Mediafile
decodeJsonMediafile =
    decode Mediafile
        |> required "fileName"          (Json.Decode.string)
        |> required "startingOffset"    (Json.Decode.int)
        |> required "checksum"          (Json.Decode.string)

decodeJsonSegment : Json.Decode.Decoder Segment
decodeJsonSegment =
    decode Segment
        |> required "id"                (Json.Decode.string)
        |> required "start"             (Json.Decode.int)
        |> required "end"               (Json.Decode.int)


--Encoding
encodeKomposition : JsonKomposition -> Json.Encode.Value
encodeKomposition record = Json.Encode.object [ ("komposition",  encodeJsonKomposition <| record.komposition) ]

encodeJsonKomposition : Model -> Json.Encode.Value
encodeJsonKomposition record = Json.Encode.object
        [ ("mediaFile",     encodeJsonMediafile <| record.mediaFile)
        , ("config",        encodeJsonConfig    <| record.config)
        , ("segments",      Json.Encode.list    <| List.map encodeSegment <| record.segments)
        ]
encodeJsonConfig : Config -> Json.Encode.Value
encodeJsonConfig record =   Json.Encode.object
        [ ("width",         Json.Encode.int     <| record.width)
        , ("height",        Json.Encode.int     <| record.height)
        , ("framerate",     Json.Encode.int     <| record.framerate)
        , ("extensionType", Json.Encode.string  <| record.extensionType)
        , ("duration",      Json.Encode.int     <| record.duration)
        ]

encodeJsonMediafile : Mediafile -> Json.Encode.Value
encodeJsonMediafile record = Json.Encode.object
        [ ("fileName",      Json.Encode.string  <| record.fileName)
        , ("startingOffset",Json.Encode.int     <| record.startingOffset)
        , ("checksum",      Json.Encode.string  <| record.checksum)
        ]

encodeSegment : Segment -> Json.Encode.Value
encodeSegment record = Json.Encode.object
        [ ("id",            Json.Encode.string  <| record.id)
        , ("start",         Json.Encode.int     <| record.start)
        , ("end",           Json.Encode.int     <| record.end)
        ]