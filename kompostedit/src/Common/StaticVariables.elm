module Common.StaticVariables exposing (komposionTypes, isKomposition, extensionTypes, evaluateMediaType, mediaTypes)
import Models.BaseModel exposing (Komposition)

komposionTypes: List String
komposionTypes = ["Audio", "Video", "Komposition"]

isKomposition: Komposition -> Bool
isKomposition komposition = komposition.dvlType == "Komposition"

extensionTypes = ["mp3", "mp4", "aac", "webm", "flac", "dvl.xml", "kompo.xml", "htmlImagelist", "jpg", "png" ]

mediaTypes = ["audio","video", "image", "metadata", "Unrecognized media type"]

evaluateMediaType: String -> String
evaluateMediaType extensionType =
    case extensionType of
            "mp4" -> "video"
            "webm" -> "video"
            "mp3" -> "audio"
            "flac" -> "audio"
            "aac" -> "audio"
            "jpg" -> "image"
            "png" -> "image"
            "dvl.xml" -> "metadata"
            "kompo.xml" -> "metadata"
            "htmlImagelist" -> "metadata"
            _ -> "Unrecognized media type"