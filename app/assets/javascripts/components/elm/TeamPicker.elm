port module TeamPicker exposing (..)

import Html exposing (Html, Attribute, beginnerProgram, programWithFlags, div, button, a, text, h2, p, label, select, option, span, input,ul, li, nav)
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
    current_team: Team,
    
    newTeam: Bool,
    showTeamList: Bool

  }

type alias Flag =
  { teams: List Team
  , current_team: Team
  }

-- UPDATE
type Msg
  = ToggleTeams Bool
  | SwitchTeam Team
  | NewTeam
  | NoOp


init : Flag -> (Model, Cmd Msg)
init flags =
  (Model flags.teams flags.current_team False False, Cmd.none)


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)
    ToggleTeams toggleFlag ->
      ({ model | showTeamList = not toggleFlag } , Cmd.none)
    SwitchTeam team ->
        ({ model | current_team = team }, Cmd.none)
    NewTeam ->
        --Debug.log new_team
        ({model | newTeam = True }, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div  []
        [ span [ onClick (ToggleTeams model.showTeamList) ] [ text model.current_team.name ] ]
    
    , viewTeamList model
    , viewNewTeam model]

viewTeamList : Model -> Html Msg
viewTeamList model =
  if model.showTeamList then
    div [ class "" ]
      [ ul [] (List.map (\(team) -> li [] [span [] [ text team.name ]]) model.teams) ]
  else
    text ""

viewNewTeam:  Model -> Html Msg
viewNewTeam model =
  div [ class "field" ]
    (if model.newTeam == True then
      [ div [ class "input", onClick NoOp ]
        [ input [ type_ "text" ] [] ] ]
    else
      [])
