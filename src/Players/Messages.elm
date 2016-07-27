module Players.Messages exposing (..)

import Http
import Players.Models exposing (PlayerId, Player)


type Msg
    = FetchAllDone (List Player)
    | FetchAllFail Http.Error
    | ShowCreate
    | ShowPlayers
    | ShowPlayer PlayerId
    | ChangeLevel PlayerId Int
    | SaveSuccess Player
    | SaveFail Http.Error
    | CreatePage CreateMsg


type CreateMsg
    = AddNewPlayerSuccess Player
    | AddNewPlayerFail Http.Error
    | Create
    | NameInput String
    | LevelInput String
