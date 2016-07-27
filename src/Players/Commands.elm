module Players.Commands exposing (..)

import Http
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Task
import Players.Models exposing (PlayerId, Player, NewPlayer)
import Players.Messages exposing (..)


fetchAll : Cmd Msg
fetchAll =
    Http.get collectionDecoder fetchAllUrl
        |> Task.perform FetchAllFail FetchAllDone


fetchAllUrl : String
fetchAllUrl =
    "http://localhost:4000/players"


collectionDecoder : Decode.Decoder (List Player)
collectionDecoder =
    Decode.list memberDecoder


memberDecoder : Decode.Decoder Player
memberDecoder =
    Decode.object3 Player
        ("id" := Decode.int)
        ("name" := Decode.string)
        ("level" := Decode.int)


urlBase : String
urlBase =
    "http://localhost:4000/players/"


playerToBody : Player -> Http.Body
playerToBody player =
    memberEncoded player
        |> Encode.encode 0
        |> Http.string


{-|
   Send a request for a single player
-}
playerRequestTask : Http.Body -> String -> String -> Task.Task Http.Error Player
playerRequestTask body verb url =
    let
        config =
            { verb = verb
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = url
            , body = body
            }
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson memberDecoder


saveTask : Player -> Task.Task Http.Error Player
saveTask player =
    playerRequestTask (playerToBody player) "PATCH" (urlBase ++ (toString player.id))


save : Player -> Cmd Msg
save player =
    saveTask player
        |> Task.perform SaveFail SaveSuccess


memberEncoded : Player -> Encode.Value
memberEncoded player =
    let
        list =
            [ ( "id", Encode.int player.id )
            , ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
        list
            |> Encode.object


createTask : NewPlayer -> Task.Task Http.Error Player
createTask newPlayer =
    playerRequestTask (newPlayerToBody newPlayer) "POST" urlBase


newPlayerToBody : NewPlayer -> Http.Body
newPlayerToBody newPlayer =
    encodeNewPlayer newPlayer
        |> Encode.encode 0
        |> Http.string


create : NewPlayer -> Cmd Msg
create player =
    createTask player
        |> Task.perform AddNewPlayerFail AddNewPlayerSuccess
        |> Cmd.map CreatePage


encodeNewPlayer : NewPlayer -> Encode.Value
encodeNewPlayer newPlayer =
    let
        list =
            [ ( "name", Encode.string newPlayer.name )
            , ( "level", Encode.int newPlayer.level )
            ]
    in
        Encode.object list
