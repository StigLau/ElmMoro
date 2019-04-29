module Common.StaticVariables exposing (evaluateMediaType, extensionTypes, isKomposition, komposionTypes, mediaTypes, audioTag, videoTag, kompositionTag)

import Models.BaseModel exposing (Komposition)


komposionTypes : List String
komposionTypes =
    [ audioTag, videoTag, kompositionTag ]

audioTag = "Audio"
videoTag = "Video"
kompositionTag = "Komposition"

isKomposition : Komposition -> Bool
isKomposition komposition =
    komposition.dvlType == kompositionTag


extensionTypes =
    [ "mp3", "mp4", "aac", "webm", "flac", "dvl.json", "kompo.json", "htmlImagelist", "jpg", "png" ]


mediaTypes =
    [ "audio", "video", "image", "metadata", "Unrecognized media type" ]


evaluateMediaType : String -> String
evaluateMediaType extensionType =
    case extensionType of
        "mp4" ->
            "video"

        "webm" ->
            "video"

        "mp3" ->
            "audio"

        "flac" ->
            "audio"

        "aac" ->
            "audio"

        "jpg" ->
            "image"

        "png" ->
            "image"

        "dvl.xml" ->
            "metadata"

        "kompo.xml" ->
            "metadata"

        "htmlImagelist" ->
            "metadata"

        _ ->
            "Unrecognized media type"
