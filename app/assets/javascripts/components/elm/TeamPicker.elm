port module TeamPicker exposing (..)

import Html exposing (Html, beginnerProgram, programWithFlags, div, button, text, h2, p, label, select, option, span, input)
import Html.Attributes exposing (class, placeholder, type_, size, value, selected, name, disabled)
import Html.Events exposing (onClick, onInput)
import String
import Debug

main =
  programWithFlags
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    }

-- MODEL
type alias Team =
  { id: String
  , name: String
  }

type alias Model =
  {
    teams: List Team,
    current_team: Team
  }

type alias Flag =
  { teams: List Team
  , current_team: Team
  }

-- UPDATE
type Msg
  = ShowTeams String
  | SwitchTeam Team
  | NewTeam String


init : Flag -> (Model, Cmd Msg)
init flags =
  (Model flags.teams flags.current_team, Cmd.none)



update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ShowTeams _ -> (model, Cmd.none)
    SwitchTeam team ->
        ({ model | current_team = team }, Cmd.none)
    NewTeam new_team ->
        Debug.log new_team
        (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] (List.map (\(team) -> span [] [ text team.name ]) model.teams),
      span []
        [ text "Current Team:", text model.current_team.name ] ]
