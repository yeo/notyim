port module TeamPicker exposing (..)

import Html exposing (Html, Attribute, beginnerProgram, programWithFlags, div, button, a, hr, text, h2, p, label, select, option, span, input,ul, li, nav)
import Html.Attributes exposing (class, placeholder, type_, size, value, selected, name, disabled, href)
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
    teams: List Team
    ,current_team: Team
    
    ,newTeam: Bool
    ,showTeamList: Bool
    ,domain: String
  }

type alias Flag =
  { domain: String
  , teams: List Team
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
  (Model flags.teams flags.current_team False False flags.domain, Cmd.none)


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
  div [ class "nav-item teampicker" ]
    [ div []
        [ span [ onClick (ToggleTeams model.showTeamList) ] [ model.current_team.name ++ (if model.showTeamList then " ˅" else " ˄" )  |> text ] ]
    , (if model.showTeamList then
       div [ class "teampicker__list box" ]
          [viewTeamList model
            , viewTeamFooter
            , viewNewTeam model]
       else
         text "")
    ]

viewTeamList : Model -> Html Msg
viewTeamList model =
  div [ class "" ]
    [ ul [] (List.map (\(team) -> li [] [
                                      span [] [ a [ href ("//team-" ++ team.id ++ "." ++ model.domain ) ] [text team.name] ]
                                     ]) model.teams) ]


viewNewTeam:  Model -> Html Msg
viewNewTeam model =
  div [ class "field" ]
    [ div [ class "input", onClick NoOp ]
      [ input [ type_ "text" ] [] ] ]

viewTeamFooter:  Html Msg
viewTeamFooter =
  div []
    [
      hr [] []
      , a [ href "/teams" ]
        [
          text "Manage teams"
        ]
    ]
