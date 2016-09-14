module Messages exposing (..)

import Model exposing (..)

type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play
