port module Main exposing (..)

import Platform
import Time exposing (every, second)


type alias Model =
    Int


type Msg
    = Increment


main =
    Platform.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        }


init =
    Debug.log "Elm init" 1 ! []


subscriptions model =
    always Increment
        |> Time.every second


update msg model =
    case msg of
        Increment ->
            let
                next =
                    Debug.log "next state" (model + 1)
            in
                next ! [ state next ]


port state : Model -> Cmd msg
