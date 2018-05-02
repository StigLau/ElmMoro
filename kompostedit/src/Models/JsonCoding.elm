module Models.JsonCoding exposing (kompositionDecoder, kompositionEncoder, couchServerStatusDecoder, kompositionListDecoder, searchEncoder)

import Json.Decode as JsonD
import Json.Encode as JsonE
import Json.Decode.Pipeline as JsonDPipe
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Models.BaseModel exposing (Komposition, Segment, Source, VideoConfig, BeatPattern, CouchStatusMessage, DataRepresentation, Row)


kompositionDecoder : JsonD.Decoder Komposition
kompositionDecoder =
    Json.Decode.Pipeline.decode Komposition
        |> required "_id" JsonD.string
        |> required "_rev" JsonD.string
        |> optional "type" JsonD.string ""
        |> optional "bpm" JsonD.float -1
        |> optional "segments" (JsonD.list segmentDecoder) []
        |> optional "sources" (JsonD.list sourceDecoder) []
        |> optional "config" configDecoder (VideoConfig 0 0 0 "")
        |> optional "beatpattern" (JsonD.map Just beatpatternDecoder) Nothing


kompositionEncoder : Komposition -> String -> String
kompositionEncoder kompo kompoUrl =
    let
        revision =
            case kompo.revision of
                "" ->
                    []

                revision ->
                    [ ( "_rev", JsonE.string revision ) ]

        sources =
            [ ( "sources", JsonE.list <| (List.map (\n -> encodeSource kompoUrl n) kompo.sources) ) ]

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
            [ ( "segments", JsonE.list <| List.map encodeSegment kompo.segments ) ]
    in
        Debug.log "Persisting"
            JsonE.encode
            0
        <|
            JsonE.object
                ([ ( "_id", JsonE.string kompo.name )
                 , ( "type", JsonE.string kompo.dvlType )
                 , ( "bpm", JsonE.float kompo.bpm )
                 ]
                    ++ revision
                    ++ config
                    ++ beatpattern
                    ++ segments
                    ++ sources
                )


searchEncoder: String -> String
searchEncoder typeIdentifier = "{\"selector\": {\"_id\": {\"$gt\": \"0\"}, \"type\": \""++ typeIdentifier ++ "\"}, \"fields\": [ \"_id\", \"_rev\" ], \"sort\": [ {\"_id\": \"asc\"} ] }" --, \"use_index\":\"komposition-index\"

couchServerStatusDecoder : JsonD.Decoder CouchStatusMessage
couchServerStatusDecoder =
    JsonD.map3 CouchStatusMessage
        (JsonD.field "id" JsonD.string)
        (JsonD.field "ok" JsonD.bool)
        (JsonD.field "rev" JsonD.string)


segmentDecoder : JsonD.Decoder Segment
segmentDecoder =
    Json.Decode.Pipeline.decode Segment
        |> required "id" JsonD.string
        |> optional "sourceid" JsonD.string ""
        |> required "start" JsonD.int
        |> optional "duration" JsonD.int 0
        |> optional "end" JsonD.int 0


sourceDecoder : JsonD.Decoder Source
sourceDecoder =
    Json.Decode.Pipeline.decode Source
        |> required "id" JsonD.string
        |> required "url" JsonD.string
        |> required "startingOffset" JsonD.float
        |> required "checksums" JsonD.string
        |> required "extension" JsonD.string
        |> required "mediatype" JsonD.string


configDecoder : JsonD.Decoder VideoConfig
configDecoder =
    Json.Decode.Pipeline.decode VideoConfig
        |> optional "width" JsonD.int 0
        |> optional "height" JsonD.int 0
        |> optional "framerate" JsonD.int 0
        |> optional "extension" JsonD.string ""


beatpatternDecoder : JsonD.Decoder BeatPattern
beatpatternDecoder =
    Json.Decode.Pipeline.decode BeatPattern
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


encodeSource : String -> Source -> JsonE.Value
encodeSource kompoUrl source =
    let
        url =
            case source.url of
                "" ->
                    (kompoUrl ++ source.id)

                url ->
                    url
    in
        JsonE.object
            [ ( "id", JsonE.string source.id )
            , ( "url", JsonE.string url )
            , ( "startingOffset", JsonE.float source.startingOffset )
            , ( "checksums", JsonE.string source.checksum )
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
    JsonD.map2 DataRepresentation
        (JsonD.field "docs" <| JsonD.list rowDecoder)
        (JsonD.field "warning" JsonD.string)
  --      (JsonD.field "bookmark" JsonD.string)



rowDecoder : JsonD.Decoder Row
rowDecoder =
    JsonD.map2 Row
        (JsonD.field "_id" JsonD.string)
        (JsonD.field "_rev" JsonD.string)