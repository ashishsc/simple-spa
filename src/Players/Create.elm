module Players.Create exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class, value, href, type', placeholder)
import Players.Models exposing (..)
import Players.Messages exposing (Msg(..), CreateMsg(..))


view : NewPlayer -> Html Msg
view newPlayer =
    div []
        [ nav
        , form newPlayer |> App.map CreatePage
        ]


form : NewPlayer -> Html.Html CreateMsg
form newPlayer =
    div [ class "m3" ]
        [ h1 [] [ text "Create a new Player" ]
        , input
            [ placeholder "Player Name", onInput NameInput ]
            [ text newPlayer.name ]
        , input
            [ placeholder "Player Level", type' "number", onInput LevelInput ]
            [ text (toString newPlayer.level) ]
        , button
            [ class "btn regular", onClick Create ]
            [ text "Create" ]
        ]


nav : Html.Html Msg
nav =
    div [ class "clearfix mb2 white bg-black p1" ]
        [ listBtn ]


listBtn : Html Msg
listBtn =
    button
        [ class "btn regular"
        , onClick ShowPlayers
        ]
        [ i [ class "fa fa-chevron-left mr1" ] [], text "List" ]
