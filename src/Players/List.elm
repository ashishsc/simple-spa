module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Players.Messages exposing (..)
import Players.Models exposing (..)
import Players.SharedViews as SharedViews


view : State -> Html Msg
view playersState =
    div []
        [ nav playersState.players
        , list playersState.players
        , SharedViews.toast playersState.notification
        ]


nav : List Player -> Html Msg
nav players =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Players" ]
        , newBtn
        ]


list : List Player -> Html Msg
list players =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Level" ]
                    , th [] [ text "Actions" ]
                    ]
                ]
            , tbody [] (List.map playerRow players)
            ]
        ]


playerRow : Player -> Html Msg
playerRow player =
    tr []
        [ td [] [ text (toString player.id) ]
        , td [] [ text player.name ]
        , td [] [ text (toString player.level) ]
        , td []
            [ editBtn player, removeBtn player ]
        ]


editBtn : Player -> Html Msg
editBtn player =
    button
        [ class "btn regular"
        , onClick (ShowPlayer player.id)
        ]
        [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]


removeBtn : Player -> Html Msg
removeBtn player =
    button
        [ class "btn regular right bg-red"
        , onClick (Remove player.id)
        ]
        [ i [ class "fa fa-minus mr1" ] [], text "Remove" ]


newBtn : Html Msg
newBtn =
    button
        [ class "btn regular right bg-green"
        , onClick (ShowCreate)
        ]
        [ i [ class "fa fa-plus mr1" ] [], text "New" ]
