module Models exposing (..)

import Players.Models exposing (initialState, State)
import Routing


type alias Model =
    { playersState : State
    , route : Routing.Route
    }


initialModel : Routing.Route -> Model
initialModel route =
    { playersState = initialState
    , route = route
    }
