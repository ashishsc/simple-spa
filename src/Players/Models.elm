module Players.Models exposing (..)


type alias PlayerId =
    Int


type alias Player =
    { id : PlayerId
    , name : String
    , level : Int
    }


new : Player
new =
    { id = 0
    , name = ""
    , level = 1
    }


type alias NewPlayer =
    { name : String
    , level : Int
    }


initialNewPlayer : NewPlayer
initialNewPlayer =
    { name = ""
    , level = 0
    }


type alias State =
    { players : List Player
    , newPlayer : NewPlayer
    , notification : Maybe String
    }


initialState : State
initialState =
    { players = []
    , newPlayer = initialNewPlayer
    , notification = Nothing
    }
