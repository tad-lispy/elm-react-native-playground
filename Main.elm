port module Main exposing (..)

import Platform


type alias Model =
    ()


main =
    Platform.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        }


init =
    Debug.log "Elm init" () ! []


subscriptions model =
    Sub.none


update msg model =
    () ! []


port state : Model -> Cmd msg
