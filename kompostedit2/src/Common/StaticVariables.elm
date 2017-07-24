module Common.StaticVariables exposing (komposionTypes, isKomposition, extensionTypes)
import Models.BaseModel exposing (Komposition)

komposionTypes: List String
komposionTypes = ["Audio", "Video", "Komposition"]

isKomposition: Komposition -> Bool
isKomposition komposition = komposition.dvlType == "Komposition"

extensionTypes = ["mp3", "mp4", "aac", "webm", "flac", "dvl.xml", "kompo.xml", "htmlImagelist", "jpg", "png" ]