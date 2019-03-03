import Browser
import Html exposing (Html, button, div, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)

main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type Model =
  Model
    { total: Int
    , field: String
    , error: Maybe String
    }

init : Model
init =
  Model {
    total = 0
    , field = "1"
    , error = Nothing
    }


-- UPDATE

type Msg = Increment | Decrement | Apply | Reset | SetValue String

update : Msg -> Model -> Model
update msg (Model m) =
  case msg of
    Increment ->
      Model { m | total = (m.total + 1) }

    Decrement ->
      Model { m | total = (m.total - 1) }

    Apply ->
      case String.toInt m.field of
        Nothing -> Model
          { m | error = Just ("Unable to parse \"" ++ m.field ++ "\"") }
        Just x -> Model { m | total = m.total + x, error = Nothing }

    SetValue x ->
      Model { m | field = x}

    Reset ->
      -- Model { m | total = init.Model.total }
      Model { m | total = case init of
        Model { total } -> total
        }


-- VIEW

view : Model -> Html Msg
view (Model {total, field, error}) =
  div []
    [ button [ onClick Increment ] [ text "+" ]
    , button [ onClick Decrement ] [ text "-" ]
    , div [ ] [ text (String.fromInt total) ]
    , div [] [ text (Maybe.withDefault "" error) ]
    , div []
      [ input
        [ value field
        , onInput SetValue
        ]
        [ ]
      , button [ onClick Apply ] [ text "Apply" ]
      , button [ onClick Reset ] [ text "Reset" ]
      ]
    ]

isOne : Int -> Bool
isOne x = case x of
  1 -> True
  _ -> False