port module Ports.WaveForm exposing (..)
import Models.Msg exposing (Msg(..))
import Models.BaseModel as Model exposing (..)

port suggestions : (List String -> msg) -> Sub msg

port check : String -> Cmd msg



subscriptions : Model -> Sub Msg
subscriptions model =
  suggestions Suggest


