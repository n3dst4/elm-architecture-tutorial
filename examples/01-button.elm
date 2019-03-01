import Browser
import Html exposing (Html, button, div, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)

main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model = { total: Int, field: String, error: Maybe String }

init : Model
init =
  { total = 0, field = "1", error = Nothing }


-- UPDATE

type Msg = Increment | Decrement | Apply | SetValue String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      { model | total = (model.total + 1) }

    Decrement ->
      { model | total = (model.total - 1) }

    Apply ->
      case String.toInt model.field of
        Nothing -> { model | error = Just ("Unable to parse \"" ++ model.field ++ "\"")}
        Just x -> { model | total = model.total + x, error = Nothing }

    SetValue x ->
      { model | field = x}


-- VIEW 

view : Model -> Html Msg
view {total, field, error} =
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
      ]
    ] 

isOne : Int -> Bool
isOne x = case x of
  1 -> True
  _ -> False