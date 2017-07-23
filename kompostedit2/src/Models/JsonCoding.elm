module Models.JsonCoding exposing (kompositionDecoder, kompositionEncoder, couchServerStatusDecoder)

import Json.Decode as JsonD
import Json.Encode as JsonE
import Json.Decode.Pipeline as JsonDPipe
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Models.BaseModel exposing (Komposition, Segment, Source, VideoConfig, BeatPattern, CouchStatusMessage)


kompositionDecoder : JsonD.Decoder Komposition
kompositionDecoder =
  Json.Decode.Pipeline.decode Komposition
    |> required "_id" JsonD.string
    |> required "_rev" JsonD.string
    |> optional "type" JsonD.string ""
    |> optional "bpm" JsonD.float -1
    |> optional "segments" (JsonD.list segmentDecoder) []
    |> optional "sources" (JsonD.list mediaFileDecoder) []
    |> optional "config" configDecoder (VideoConfig 0 0 0 "")
    |> optional "beatpattern" (JsonD.map Just beatpatternDecoder) Nothing

kompositionEncoder : Komposition -> String -> String
kompositionEncoder kompo kompoUrl =
    let
        revision = case kompo.revision of
               "" -> []
               revision -> [( "_rev", JsonE.string revision )]
        sources = [( "sources", JsonE.list <| (List.map (\n -> encodeMediaFile kompoUrl n) kompo.sources ))]
        config = case kompo.dvlType of
            "Komposition" ->
                [ ( "config", encodeConfig kompo.config) ]
            _ -> []
        beatpattern = case kompo.beatpattern of
            (Just bpm) -> [ ("beatpattern", encodeBeatPattern bpm)]
            _ -> []
        segments = [ ( "segments", JsonE.list <| List.map encodeSegment kompo.segments ) ]
     in Debug.log "Persisting"
        JsonE.encode 0 <| JsonE.object (
            [ ( "_id", JsonE.string kompo.name )
            , ( "type", JsonE.string kompo.dvlType )
            , ( "bpm", JsonE.float kompo.bpm)
            ]   ++ revision ++  config ++ beatpattern ++ segments ++ sources
        )

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

mediaFileDecoder : JsonD.Decoder Source
mediaFileDecoder =
  Json.Decode.Pipeline.decode Source
    |> required "id" JsonD.string
    |> optional "url" JsonD.string ""
    |> optional "startingOffset" JsonD.float 0
    |> optional "checksum" JsonD.string ""

configDecoder: JsonD.Decoder VideoConfig
configDecoder =
    Json.Decode.Pipeline.decode VideoConfig
        |> optional "width" JsonD.int 0
        |> optional "height" JsonD.int 0
        |> optional "framerate" JsonD.int 0
        |> optional "extensiontype" JsonD.string ""

beatpatternDecoder: JsonD.Decoder BeatPattern
beatpatternDecoder =
    Json.Decode.Pipeline.decode BeatPattern
        |> optional "frombeat" JsonD.int 0
        |> optional "tobeat" JsonD.int 0
        |> optional "masterbpm" JsonD.float 0

encodeBeatPattern : BeatPattern -> JsonE.Value
encodeBeatPattern beatpattern = JsonE.object
    [ ( "frombeat", JsonE.int beatpattern.fromBeat )
    , ( "tobeat", JsonE.int beatpattern.toBeat )
    , ( "masterbpm", JsonE.float beatpattern.masterBPM )
    ]

encodeMediaFile : String -> Source -> JsonE.Value
encodeMediaFile kompoUrl mediaFile =
    let url = case mediaFile.url of
            "" -> (kompoUrl ++ mediaFile.id)
            url -> url
    in JsonE.object
        [ ( "id", JsonE.string mediaFile.id )
        , ( "url", JsonE.string url )
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

encodeConfig : VideoConfig -> JsonE.Value
encodeConfig config =
    JsonE.object
        [ ( "width", JsonE.int config.width )
        , ( "height", JsonE.int config.height )
        , ( "framerate", JsonE.int config.framerate )
        , ( "extensiontype", JsonE.string config.extensionType )
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