module Controller exposing (..)

import Messages exposing (..)
import Model exposing (..)
import String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetSegmentName name -> { model | name  = name  }
        SetSegmentStart start -> { model | start = start }
        SetSegmentEnd end -> { model | end = end }

        Create -> model



{-
        Save ->
            if (String.isEmpty model.name) then
                model
            else
                save model




save : Model -> Model
save model =
    case model.playerId of
        Just id ->
            edit model id

        Nothing ->
            add model



add : Model -> Model
add model =
    let
        player =
            Player (List.length model.players) model.name 0

        newPlayers =
            player :: model.players
    in
        { model
            | players = newPlayers
            , name = ""
        }

-}

