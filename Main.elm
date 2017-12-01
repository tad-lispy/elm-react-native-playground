port module Main exposing (..)

import Platform
import Json.Decode as Decode
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
        decoder =
            Decode.field "kind" Decode.string
                |> Decode.andThen eventDecoder

        eventDecoder : String -> Decode.Decoder Msg
        eventDecoder kind =
            case kind of
                "Decrement" ->
                    Decode.succeed Decrement

                _ ->
                    Decode.fail "Usupported event"

        handleEvent : Decode.Value -> Msg
        handleEvent json =
            json
                -- Circular references will crash runtime
                -- |> Debug.log "Elm received"
                |> Decode.decodeValue decoder
                |> Result.withDefault NoOp
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


port events : (Decode.Value -> msg) -> Sub msg
