port module AssertEditor exposing (..)

import Html exposing (Html, beginnerProgram, programWithFlags, div, button, text, h2, p, label, select, option, span, input)
import Html.Attributes exposing (class, placeholder, type_, size, value, selected, name, disabled)
import Html.Events exposing (onClick, onInput)
import String
import Debug

main =
  --beginnerProgram { model = model, view = view, update = update }
  programWithFlags
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    }

type alias Subject =
  List SubjectItem
type alias SubjectItem =
  (String, String)

type alias Condition =
  List ConditionItem
type alias ConditionItem =
  { op: String
  , text: String
  }

type alias Flags =
  { assert : Assert
  , subjects : Subject
  , conditions: Condition
  }

init: Flags -> (Model, Cmd Msg)
init flags =
  (Model flags.assert flags.subjects flags.conditions, Cmd.none)

-- Model
type alias Model =
  { assert : Assert
  , subjects: Subject
  , conditions: Condition
  }

type alias Assert =
  { subject : String
  , condition: String
  , operand: String
  }



-- View
view : Model -> Html Msg
view model =
  div [ class "control is-horizontal" ]
    [ p [class "control-label"] [ label [ class "label"] [ text "When"] ]
    , p [class "control"]
        [span [ class "select" ]
          [ select [name "assertion[subject]", onInput SelectSubject ]
            (List.map (\(subject, label) ->
              option [ value subject, selected (subject == model.assert.subject) ] [ text label ]) model.subjects)
          ]
        ]
    , p [class "control-label" ] [ label [ class "label" ] [ text "Is" ] ]
    , p [class "control"]
        [span [ class "select" ]
          [ select [name "assertion[condition]", onInput SelectCondition ]
            (List.map (viewCondition model) (model.conditions |> List.filter (findCondition model)))
          ]
        ]
    , p [class "control-label" ] [ label [ class "label" ] [ text "Value" ] ]
    , p [class "control"]
        [ input [ name "assertion[operand]", type_ "text", placeholder "threshold", class "input is-expanded", size 20, onInput Operand, value model.assert.operand, disabled (disabledOperand model) ] []
        , input [ type_ "submit", value "Save", class "button is-primary" ] []]
    ]

findCondition : Model -> ConditionItem -> Bool
findCondition model conditionItem =
  case String.split "." model.assert.subject of
    [_, "status"] ->
      List.member conditionItem.op ["up", "down"]
    [_, "body"] ->
      List.member conditionItem.op ["contain"]
    [_, "code"] ->
      List.member conditionItem.op ["eq", "ne", "gt", "lt", "in"]
    [_, "response_time"] ->
      List.member conditionItem.op ["gt", "lt"]
    _ -> False

viewCondition : Model -> ConditionItem -> Html Msg
viewCondition model condition =
  option [ selected (condition.op == model.assert.condition) ] [ text condition.text ]

disabledOperand : Model -> Bool
disabledOperand model =
  case model.assert.subject of
    "http.status" -> True
    _ -> False

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
        foo = Debug.log operand
        updateAssert a =
          { a | operand = operand }
      in
        ({ model | assert = updateAssert model.assert }, Cmd.none)
