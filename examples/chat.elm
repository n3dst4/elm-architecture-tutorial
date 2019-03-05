module Main exposing
    ( Model
    , Msg(..)
    , bypassNastiness
    , formatMessage
    , init
    , jumpToBottom
    , main
    , subscriptions
    , update
    , view
    )

import Array exposing (Array)
import Browser
import Browser.Dom as Dom
import Html exposing (Html, button, div, form, h1, input, text)
import Html.Attributes exposing (id, style, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Task


main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Model =
    { messages : Array String
    , commands : Array String
    , entryField : String
    }


type Msg
    = EditField String
    | Enter
    | Nada


bypassNastiness : a -> Task.Task x a -> Task.Task Never a
bypassNastiness fallbackValue =
    Task.onError
        (\_ -> Task.succeed fallbackValue)


jumpToBottom : String -> Cmd Msg
jumpToBottom id =
    Dom.getViewportOf id
        |> Task.andThen (\info -> Dom.setViewportOf id 0 info.scene.height)
        |> bypassNastiness ()
        |> Task.perform (\_ -> Nada)


init : () -> ( Model, Cmd Msg )
init _ =
    ( { messages = Array.fromList [ "Start of game" ]
      , commands = Array.fromList []
      , entryField = ""
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EditField s ->
            ( { model | entryField = s }
            , Cmd.none
            )

        Enter ->
            ( { model
                | entryField = ""
                , commands = Array.push model.entryField model.commands
                , messages =
                    Array.push
                        ("You said \"" ++ model.entryField ++ "\"")
                        model.messages
              }
            , jumpToBottom "messages"
            )

        _ ->
            ( model, Cmd.none )


formatMessage : String -> Html msg
formatMessage message =
    div
        []
        [ text message ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "hi" ]
        , div
            [ id "messages"
            , style "background" "#eee"
            , style "height" "20em"
            , style "overflow-y" "auto"
            ]
            (Array.toList (Array.map formatMessage model.messages))
        , div
            []
            [ form
                [ onSubmit Enter
                , style "display" "flex"
                , style "flex-direction" "row"
                ]
                [ input
                    [ onInput EditField
                    , value model.entryField
                    , style "flex" "1"
                    ]
                    []
                , button
                    []
                    [ text "Go" ]
                ]
            ]
        ]
