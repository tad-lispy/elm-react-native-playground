port module Main exposing (..)

import Platform
import Json.Decode
import Time exposing (every, second)


type alias Model =
    { count : Int }


type Msg
    = NoOp
    | Increment
    | Decrement


main : Program Never Model Msg
main =
    Platform.program
        { init = init
        , subscriptions = subscriptions
        , update = updateAndSend
        }


init : ( Model, Cmd Msg )
init =
    Debug.log "Elm init" Model 0 ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        handleEvent : String -> Msg
        handleEvent event =
            case (Debug.log "Elm received" event) of
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "Update" msg) of
        NoOp ->
            model ! []

        Increment ->
            { model | count = model.count + 1 } ! []

        Decrement ->
            { model | count = model.count - 1 } ! []


updateAndSend : Msg -> Model -> ( Model, Cmd Msg )
updateAndSend msg model =
    let
        ( next, cmd ) =
            update msg model

        _ =
            Debug.log "Elm sending" next
    in
        next ! [ cmd, state next ]


port state : Model -> Cmd msg


port events : (String -> msg) -> Sub msg
