module View exposing (..)

import Html exposing (Html, div, text)
import Html.App
import Messages exposing (Msg(..))
import Models exposing (Model)
import Players.List
import Players.Edit
import Players.Create
import Players.Models exposing (PlayerId, State, Player)
import Routing exposing (Route(..))


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        PlayersRoute ->
            Html.App.map PlayersMsg (Players.List.view model.playersState.players)

        PlayerRoute id ->
            playerEditPage model.playersState.players id

        NewPlayerRoute ->
            Html.App.map PlayersMsg (Players.Create.view model.playersState.newPlayer)

        NotFoundRoute ->
            notFoundView


playerEditPage : List Player -> PlayerId -> Html Msg
playerEditPage players playerId =
    let
        maybePlayer =
            players
                |> List.filter (\player -> player.id == playerId)
                |> List.head
    in
        case maybePlayer of
            Just player ->
                Html.App.map PlayersMsg (Players.Edit.view player)

            Nothing ->
                notFoundView


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found" ]
