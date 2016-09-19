module Model exposing (..)

import Random exposing (..)

type alias Model =
    { players : List Player
    , name : String
    , playerId : Maybe Int
    , plays : List Play
    }


type alias Player =
    { id : Int
    , name : String
    , points : Int
    }

type alias Play =
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }




initModel : Model
initModel =
    { players = playaz
    , name = "Johnny Golf"
    , playerId = Nothing
    , plays = []
    }





ladyplayer : Player
ladyplayer =
  { name = "Lois Lane"
  , points = 31
  , id = 3
  }


dude : Player
dude =
  { id = 0
  , points = 0
  , name = "Clark Kent"
  }


spoof = Player 1 "Gunnar" 0
goof = Player 3 "Leif" 6

playaz = [spoof, goof, ladyplayer, dude]
