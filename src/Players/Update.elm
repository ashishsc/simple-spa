module Players.Update exposing (..)

import Players.Messages exposing (Msg(..), CreateMsg(..))
import Players.Commands exposing (..)
import Players.Models exposing (..)
import String
import Navigation
import Http exposing (Error(..))


update : Msg -> State -> ( State, Cmd Msg )
update action state =
    case action of
        FetchAllDone newPlayers ->
            ( { state | players = newPlayers }, Cmd.none )

        FetchAllFail error ->
            ( { state | notification = Just (httpErrorToString error) }, Cmd.none )

        ShowPlayers ->
            ( state, navigateToListView )

        ShowPlayer id ->
            ( state, Navigation.newUrl ("#players/" ++ (toString id)) )

        ShowCreate ->
            ( state, Navigation.newUrl ("#players/new") )

        ChangeLevel id howMuch ->
            ( state, changeLevelCommands id howMuch state.players |> Cmd.batch )

        SaveSuccess updatedPlayer ->
            ( { state | players = updatePlayer updatedPlayer state.players }, Cmd.none )

        SaveFail error ->
            ( { state | notification = Just (httpErrorToString error) }, Cmd.none )

        CreatePage createMsg ->
            let
                newPlayer =
                    state.newPlayer

                players =
                    state.players
            in
                case createMsg of
                    NameInput newName ->
                        ( { state | newPlayer = { newPlayer | name = newName } }, Cmd.none )

                    LevelInput newLevel ->
                        let
                            parsedLevel =
                                Result.withDefault newPlayer.level (String.toInt newLevel)
                        in
                            ( { state | newPlayer = { newPlayer | level = parsedLevel } }
                            , Cmd.none
                            )

                    Create ->
                        ( state, create newPlayer )

                    AddNewPlayerSuccess player ->
                        ( { state
                            | newPlayer = initialNewPlayer
                            , players = player :: players
                            , notification = Just (player.name ++ " succesfully added")
                          }
                        , navigateToListView
                        )

                    AddNewPlayerFail _ ->
                        -- TODO add something to the model to store this error
                        ( state, Cmd.none )

        Remove playerId ->
            ( state, remove playerId )

        RemoveSuccess playerId ->
            ( { state
                | players = removePlayer playerId state.players
                , notification = Just "Player removed"
              }
            , Cmd.none
            )

        RemoveFail error ->
            ( { state | notification = Just (httpErrorToString error) }, Cmd.none )

        Notify notification ->
            ( { state | notification = Just notification }, Cmd.none )

        DismissNotification ->
            ( { state | notification = Nothing }, Cmd.none )


httpErrorToString : Http.Error -> String
httpErrorToString error =
    case error of
        Timeout ->
            "Network Timeout"

        NetworkError ->
            "Network Error"

        UnexpectedPayload payload ->
            "Unexpected Payload returned" ++ payload

        BadResponse statusCode message ->
            "Bad Response(" ++ (toString statusCode) ++ ") " ++ message


navigateToListView : Cmd Msg
navigateToListView =
    Navigation.newUrl ("#players")


removePlayer : PlayerId -> (List Player -> List Player)
removePlayer playerId =
    List.filter (\player -> player.id /= playerId)


changeLevelCommands : PlayerId -> Int -> List Player -> List (Cmd Msg)
changeLevelCommands playerId howMuch =
    let
        cmdForPlayer existingPlayer =
            if (existingPlayer.id == playerId) then
                save { existingPlayer | level = existingPlayer.level + howMuch }
            else
                Cmd.none
    in
        List.map cmdForPlayer


updatePlayer : Player -> List Player -> List Player
updatePlayer updatedPlayer =
    let
        select existingPlayer =
            if existingPlayer.id == updatedPlayer.id then
                updatedPlayer
            else
                existingPlayer
    in
        List.map select
