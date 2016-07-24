module Players.Update exposing (..)

import Players.Messages exposing (Msg(..))
import Players.Models exposing (Player)
import Navigation


update : Msg -> List Player -> ( List Player, Cmd Msg )
update action players =
    case action of
        FetchAllDone newPlayers ->
            ( newPlayers, Cmd.none )

        FetchAllFail error ->
            ( players, Cmd.none )

        ShowPlayers ->
            ( players, Navigation.modifyUrl "#players" )

        ShowPlayer id ->
            ( players, Navigation.modifyUrl ("#players/" ++ (toString id)) )
