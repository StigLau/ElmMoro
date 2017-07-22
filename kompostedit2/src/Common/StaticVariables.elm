module Common.StaticVariables exposing (komposionTypes, isKomposition)
import Models.BaseModel exposing (Komposition)

komposionTypes: List String
komposionTypes = ["Komposition", "Audio", "Video"]

isKomposition: Komposition -> Bool
isKomposition komposition = komposition.dvlType == "Komposition"