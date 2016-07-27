module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Players.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlayersMsg subMsg ->
            let
                ( updatedPlayersState, cmd ) =
                    Players.Update.update subMsg model.playersState
            in
                ( { model | playersState = updatedPlayersState }, Cmd.map PlayersMsg cmd )
