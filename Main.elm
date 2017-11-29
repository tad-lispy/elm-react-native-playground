port module Main exposing (..)

import Platform
import Json.Decode
import Time exposing (every, second)


type alias Model =
    Int


type Msg
    = NoOp
    | Increment
    | Decrement


main =
    Platform.program
        { init = init
        , subscriptions = subscriptions
        , update = updateAndSend
        }


init =
    Debug.log "Elm init" 1 ! []


subscriptions model =
    let
        handleEvent event =
            case event of
                "Decrement" ->
                    Decrement

                _ ->
                    NoOp
    in
        Sub.batch
            [ always Increment
                |> Time.every second
            , events handleEvent
            ]


update msg model =
    case msg of
        NoOp ->
            model ! []

        Increment ->
            (model + 1) ! []

        Decrement ->
            (model - 1) ! []


updateAndSend msg model =
    let
        ( next, cmd ) =
            update msg model

        _ =
            Debug.log "Sending" next
    in
        next ! [ cmd, state next ]


port state : Model -> Cmd msg


port events : (String -> msg) -> Sub msg
