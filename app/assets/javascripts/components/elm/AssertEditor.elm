port module AssertEditor exposing (..)

import Html exposing (Html, beginnerProgram, div, button, text, h2, p, label, select, option, span, input)
import Html.Attributes exposing (class, placeholder, type_, size)
import Html.Events exposing (onClick, onInput)

main =
  beginnerProgram { model = model, view = view, update = update }


-- Model
type alias Model =
  { subject : String
  , condition: String
  , operand: String
  }

model: Model
model =
  Model "TCP" "slow" "300"


-- View
view : Model -> Html Msg
view model =
  div [ class "control is-horizontal" ]
    [ p [class "control-label"] [ label [ class "label"] [ text "When"] ]
    , p [class "control"]
        [span [ class "select" ]
          [ select []
            [ option [] [ text "1" ]
            , option [] [ text "2" ]
            ]
          ]
        ]
    , p [class "control-label" ] [ label [ class "label" ] [ text "is" ] ]
    , p [class "control"]
        [span [ class "select" ]
          [ select []
            [ option [] [ text "100" ]
            , option [] [ text "200" ]
            ]
          ]
        ]
    , p [class "control-label" ] [ label [ class "label" ] [ text "threshold" ] ]
    , p [class "control"]
        [ input [ type_ "text", placeholder "threshold", class "input", size 20, onInput Operand ] []]
    ]


-- Update
type Msg
  = SelectSubject String
  | SelectCondition String
  | Operand String


update: Msg -> Model -> Model
update msg model =
  case msg of
    SelectSubject subject ->
      { model | subject = subject }
    SelectCondition condition ->
      { model | condition = condition }
    Operand operand ->
      { model | operand = operand }
