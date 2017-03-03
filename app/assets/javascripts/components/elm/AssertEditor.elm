port module AssertEditor exposing (..)

import Html exposing (Html, beginnerProgram, programWithFlags, div, button, text, h2, p, label, select, option, span, input)
import Html.Attributes exposing (class, placeholder, type_, size)
import Html.Events exposing (onClick, onInput)

main =
  --beginnerProgram { model = model, view = view, update = update }
  programWithFlags
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    }

type alias Flags =
  { assert : Assert
  , subjects : List String
  , conditions: List String
  }

init: Flags -> (Model, Cmd Msg)
init flags =
  (Model flags.assert flags.subjects flags.conditions, Cmd.none)

-- Model
type alias Model =
  { assert : Assert
  , subjects: List String
  , conditions: List String
  }
type alias Assert =
  { subject : String
  , condition: String
  , operand: String
  }

-- model: Model
-- model =
--  Model "TCP" "slow" "300"


-- View
view : Model -> Html Msg
view model =
  div [ class "control is-horizontal" ]
    [ p [class "control-label"] [ label [ class "label"] [ text "When"] ]
    , p [class "control"]
        [span [ class "select" ]
          [ select []
            (List.map (\(item) -> option [] [ text item ]) model.subjects)
          ]
        ]
    , p [class "control-label" ] [ label [ class "label" ] [ text "is" ] ]
    , p [class "control"]
        [span [ class "select" ]
          [ select []
            (List.map (\(item) -> option [] [ text item ]) model.conditions)
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

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SelectSubject subject ->
      let
        updateAssert a =
          { a | subject = subject }
      in
        ({ model | assert = updateAssert model.assert }, Cmd.none)
    SelectCondition condition ->
      let
        updateAssert a =
          { a | condition = condition }
      in
        ({ model | assert = updateAssert model.assert }, Cmd.none)
    Operand operand ->
      let
        updateAssert a =
          { a | operand = operand }
      in
        ({ model | assert = updateAssert model.assert }, Cmd.none)
