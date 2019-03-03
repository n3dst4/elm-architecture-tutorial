import Browser
import Html exposing (Html, div, text, h1, input, button, form)
import Html.Attributes exposing (style, value)
import Html.Events exposing (onInput, onClick, onSubmit)
import Array exposing (Array)


main = Browser.sandbox { init = init, update = update, view = view }

type alias Model =
  { messages: Array String
  , commands: Array String
  , entryField: String
  }

type Msg
  = EditField String
  | Enter

init : Model
init =
  { messages = Array.fromList ["Start of game"]
  , commands = Array.fromList []
  , entryField = ""
  }

update : Msg -> Model -> Model
update msg model =
  case msg of
    EditField s ->
      { model | entryField = s }
    Enter ->
      { model
        | entryField = ""
        , commands = Array.push model.entryField model.commands
        , messages = Array.push ("You said \"" ++ model.entryField ++ "\"") model.messages
        }
    -- _ ->
    --   model

formatMessage : String -> Html msg
formatMessage message =
  div
    [ ]
    [ text message ]

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [text "hi"]
    , div
        [ style "background" "#eee"
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
              [ onInput EditField, value model.entryField
              , style "flex" "1"
              ]
              []
            , button
              []
              [text "Go"]
            ]
        ]
    ]
