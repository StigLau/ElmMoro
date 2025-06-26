module SimpleTests exposing (..)

import Test exposing (..)
import Expect
import Models.BaseModel exposing (Source, Komposition, Segment, VideoConfig)


all : Test
all =
    describe "KompostEdit Core Tests"
        [ kompositionTests
        , sourceTests
        , segmentTests
        ]


kompositionTests : Test
kompositionTests =
    describe "Komposition Tests"
        [ test "Create basic komposition" <|
            \_ ->
                let
                    kompo = createTestKomposition "test-1" "Test Video" 120.0
                in
                Expect.all
                    [ \k -> Expect.equal "test-1" k.id
                    , \k -> Expect.equal "Test Video" k.name
                    , \k -> Expect.equal 120.0 k.bpm
                    , \k -> Expect.equal "video" k.dvlType
                    ] kompo
        
        , test "Komposition name validation" <|
            \_ ->
                let
                    validName = "My Video Project"
                    emptyName = ""
                    
                    isValidName name = String.length name > 0 && String.length name <= 100
                in
                Expect.all
                    [ \_ -> Expect.equal True (isValidName validName)
                    , \_ -> Expect.equal False (isValidName emptyName)
                    ] ()
        ]


sourceTests : Test
sourceTests =
    describe "Source Tests"
        [ test "Create video source" <|
            \_ ->
                let
                    source = createVideoSource "vid1" "test.mp4" 1920 1080
                in
                Expect.all
                    [ \s -> Expect.equal "vid1" s.id
                    , \s -> Expect.equal "test.mp4" s.url
                    , \s -> Expect.equal "video" s.extensionType
                    , \s -> Expect.equal (Just 1920) s.width
                    , \s -> Expect.equal (Just 1080) s.height
                    ] source
        
        , test "Create audio source" <|
            \_ ->
                let
                    source = createAudioSource "aud1" "music.mp3"
                in
                Expect.all
                    [ \s -> Expect.equal "aud1" s.id
                    , \s -> Expect.equal "music.mp3" s.url
                    , \s -> Expect.equal "audio" s.extensionType
                    , \s -> Expect.equal Nothing s.width
                    , \s -> Expect.equal Nothing s.height
                    ] source
        ]


segmentTests : Test
segmentTests =
    describe "Segment Tests"
        [ test "Create segment with timing" <|
            \_ ->
                let
                    segment = createTestSegment "seg1" "source1" 1000 3000
                in
                Expect.all
                    [ \s -> Expect.equal "seg1" s.id
                    , \s -> Expect.equal "source1" s.sourceId
                    , \s -> Expect.equal 1000 s.start
                    , \s -> Expect.equal 3000 s.duration
                    , \s -> Expect.equal 4000 s.end
                    ] segment
        
        , test "Segment timing consistency" <|
            \_ ->
                let
                    segment = createTestSegment "timing" "src" 500 2500
                    expectedEnd = segment.start + segment.duration
                in
                Expect.equal expectedEnd segment.end
        ]


-- Test helper functions
createTestKomposition : String -> String -> Float -> Komposition
createTestKomposition id name bpm =
    { id = id
    , name = name
    , revision = "1.0"
    , dvlType = "video"
    , bpm = bpm
    , segments = []
    , sources = []
    , config = defaultVideoConfig
    , beatpattern = Nothing
    }


createVideoSource : String -> String -> Int -> Int -> Source
createVideoSource id url width height =
    { id = id
    , url = url
    , startingOffset = Nothing
    , checksum = id ++ "-checksum"
    , format = "mp4"
    , extensionType = "video"
    , mediaType = "video/mp4"
    , width = Just width
    , height = Just height
    }


createAudioSource : String -> String -> Source
createAudioSource id url =
    { id = id
    , url = url
    , startingOffset = Nothing
    , checksum = id ++ "-checksum"
    , format = "mp3"
    , extensionType = "audio"
    , mediaType = "audio/mpeg"
    , width = Nothing
    , height = Nothing
    }


createTestSegment : String -> String -> Int -> Int -> Segment
createTestSegment id sourceId start duration =
    { id = id
    , sourceId = sourceId
    , start = start
    , duration = duration
    , end = start + duration
    }


defaultVideoConfig : VideoConfig
defaultVideoConfig =
    { width = 1920
    , height = 1080
    , framerate = 30
    , extensionType = "mp4"
    }