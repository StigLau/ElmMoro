module Models.JsonCoding exposing (couchServerStatusDecoder, kompositionDecoder, kompositionEncoder, kompositionListDecoder, searchEncoder)

import Json.Decode as JsonD
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as JsonE exposing (list)
import Models.BaseModel exposing (BeatPattern, CouchStatusMessage, DataRepresentation, Komposition, Row, Segment, Source, VideoConfig)


kompositionDecoder : JsonD.Decoder Komposition
kompositionDecoder =
    JsonD.succeed Komposition
        |> required "_id" JsonD.string
        |> optional "name" JsonD.string ""
        |> optional "_rev" JsonD.string ""
        |> optional "type" JsonD.string ""
        |> optional "bpm" JsonD.float -1
        |> optional "segments" (JsonD.list segmentDecoder) []
        |> optional "sources" (JsonD.list sourceDecoder) []
        |> optional "config" configDecoder (VideoConfig 0 0 0 "")
        |> optional "beatpattern" (JsonD.map Just beatpatternDecoder) Nothing


kompositionEncoder : Komposition -> String
kompositionEncoder kompo =
    let
        revision =
            case kompo.revision of
                "" ->
                    []

                theRevision ->
                    [ ( "_rev", JsonE.string theRevision ) ]

        sources =
            [ ( "sources", (list encodeSource kompo.sources))]

        config =
            case kompo.dvlType of
                "Komposition" ->
                    [ ( "config", encodeConfig kompo.config ) ]

                _ ->
                    []

        beatpattern =
            case kompo.beatpattern of
                Just bpm ->
                    [ ( "beatpattern", encodeBeatPattern bpm ) ]

                _ ->
                    []

        segments =
            [ ( "segments",  (list encodeSegment kompo.segments))]

    in
        JsonE.encode 0 <| JsonE.object
            ([ ( "_id", JsonE.string kompo.id )
             , ( "name", JsonE.string kompo.name )
             , ( "type", JsonE.string kompo.dvlType )
             , ( "bpm", JsonE.float kompo.bpm )
             ]
                ++ revision
                ++ config
                ++ beatpattern
                ++ segments
                ++ sources
            )

--, \"use_index\":\"komposition-index\"
searchEncoder : String -> String
searchEncoder typeIdentifier =
    "{\"selector\": {\"_id\": {\"$gt\": \"0\"}, \"type\": \"" ++ typeIdentifier ++ "\"}, \"fields\": [ \"_id\", \"_rev\" ], \"sort\": [ {\"_id\": \"asc\"} ] }"

couchServerStatusDecoder : JsonD.Decoder CouchStatusMessage
couchServerStatusDecoder =
    JsonD.map3 CouchStatusMessage
        (JsonD.field "id" JsonD.string)
        (JsonD.field "ok" JsonD.bool)
        (JsonD.field "rev" JsonD.string)


segmentDecoder : JsonD.Decoder Segment
segmentDecoder =
    JsonD.succeed Segment
        |> required "id" JsonD.string
        |> optional "sourceid" JsonD.string ""
        |> required "start" JsonD.int
        |> optional "duration" JsonD.int 0
        |> optional "end" JsonD.int 0


sourceDecoder : JsonD.Decoder Source
sourceDecoder =
    JsonD.succeed Source
        |> required "id" JsonD.string
        |> required "url" JsonD.string
        |> optional "startingOffset" (JsonD.maybe JsonD.float) Nothing
        |> required "checksums" JsonD.string
        |> optional "format" JsonD.string ""
        |> required "extension" JsonD.string
        |> required "mediatype" JsonD.string
        |> optional "width" (JsonD.maybe JsonD.int) Nothing
        |> optional "height" (JsonD.maybe JsonD.int) Nothing

configDecoder : JsonD.Decoder VideoConfig
configDecoder =
    JsonD.succeed VideoConfig
        |> optional "width" JsonD.int 0
        |> optional "height" JsonD.int 0
        |> optional "framerate" JsonD.int 0
        |> optional "extension" JsonD.string ""


beatpatternDecoder : JsonD.Decoder BeatPattern
beatpatternDecoder =
    JsonD.succeed BeatPattern
        |> optional "frombeat" JsonD.int 0
        |> optional "tobeat" JsonD.int 0
        |> optional "masterbpm" JsonD.float 0


encodeBeatPattern : BeatPattern -> JsonE.Value
encodeBeatPattern beatpattern =
    JsonE.object
        [ ( "frombeat", JsonE.int beatpattern.fromBeat )
        , ( "tobeat", JsonE.int beatpattern.toBeat )
        , ( "masterbpm", JsonE.float beatpattern.masterBPM )
        ]


encodeSource : Source -> JsonE.Value
encodeSource source =
    let start = case source.startingOffset of
         Just x -> JsonE.float x
         _ -> JsonE.null
    in JsonE.object
        [ ( "id", JsonE.string source.id )
        , ( "url", JsonE.string source.url ) -- "https://heap.kompo.se/" was pulled out
        , ( "startingOffset", start )
        , ( "checksums", JsonE.string source.checksum )
        , ( "format", JsonE.string source.format )
        , ( "extension", JsonE.string source.extensionType )
        , ( "mediatype", JsonE.string source.mediaType )
        ]


encodeSegment : Segment -> JsonE.Value
encodeSegment segment =
    JsonE.object
        [ ( "id", JsonE.string segment.id )
        , ( "sourceid", JsonE.string segment.sourceId )
        , ( "start", JsonE.int segment.start )
        , ( "duration", JsonE.int segment.duration )
        , ( "end", JsonE.int segment.end )
        ]


encodeConfig : VideoConfig -> JsonE.Value
encodeConfig config =
    JsonE.object
        [ ( "width", JsonE.int config.width )
        , ( "height", JsonE.int config.height )
        , ( "framerate", JsonE.int config.framerate )
        , ( "extension", JsonE.string config.extensionType )
        ]

kompositionListDecoder : JsonD.Decoder DataRepresentation
kompositionListDecoder =
    JsonD.map3 DataRepresentation
        (JsonD.field "docs" <| JsonD.list rowDecoder)
        (JsonD.field "bookmark" JsonD.string)
        (JsonD.field "warning" JsonD.string)


rowDecoder : JsonD.Decoder Row
rowDecoder =
    JsonD.map2 Row
        (JsonD.field "_id" JsonD.string)
        (JsonD.field "_rev" JsonD.string)
