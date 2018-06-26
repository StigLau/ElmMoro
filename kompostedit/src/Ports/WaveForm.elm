port module Ports.WaveForm exposing (..)
import Models.Msg exposing (Msg(..))
import Models.BaseModel as Model exposing (..)

port suggestions : (String -> msg) -> Sub msg

port exportJsonKompositionToJavascript : String -> Cmd msg



subscriptions : Model -> Sub Msg
subscriptions model =
  suggestions Suggest


