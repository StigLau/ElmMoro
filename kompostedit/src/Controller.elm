module Controller exposing (..)

import Messages exposing (..)
import Model exposing (..)
import String


update : Msg -> DvlKomposition -> DvlKomposition
update msg komposition =
    case msg of
        Input reference -> komposition -- { komposition | reference  = reference  }

        Create -> komposition



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

