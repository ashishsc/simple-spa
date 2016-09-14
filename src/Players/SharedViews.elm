module Players.SharedViews exposing (toast)

import Players.Messages exposing (Msg(..))
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html exposing (..)


toast : Maybe String -> Html Msg
toast maybeMessage =
    let
        hideClass =
            case maybeMessage of
                Nothing ->
                    "hide"

                Just message ->
                    ""
    in
        div [ class ("absolute " ++ hideClass), onClick DismissNotification ]
            [ text (Maybe.withDefault "" maybeMessage) ]
