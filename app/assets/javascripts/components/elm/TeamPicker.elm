port module TeamPicker exposing (..)

import Html exposing (Html, Attribute, beginnerProgram, programWithFlags, div, button, a, hr, text, h2, p, label, select, option, span, input,ul, li, nav, form)
import Html.Attributes exposing (class, placeholder, type_, size, value, selected, name, disabled, href, method, action)
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

    , newTeam: Bool
    , showTeamList: Bool
    , domain: String
    , formAuthenticityToken: String
  }

type alias Flag =
  { formAuthenticityToken: String
  , domain: String
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
  (Model flags.teams flags.current_team False False flags.domain flags.formAuthenticityToken, Cmd.none)


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
        [
          a  [ class "button", onClick (ToggleTeams model.showTeamList) ] [ 
                text model.current_team.name
                , span  [] [(if model.showTeamList then " ▲" else " ▼" ) |> text]
             ]
        ]
    , (if model.showTeamList then
       div [ class "teampicker__list box" ]
          [
            viewTeamList model
            , viewTeamFooter model
            , viewNewTeam model
          ]
       else
         text "")
    ]

viewTeamList : Model -> Html Msg
viewTeamList model =
  div [ class "menu" ] [
    p [ class "menu-label" ] [ text "Switch team" ]
    , ul [ class "menu-list" ] (List.map (\(team) -> li [] [
                                    span [] [ a [ href ("//team-" ++ team.id ++ "." ++ model.domain ++ "/dashboard") ] [text team.name] ]
                                   ]) model.teams)
  ]

viewNewTeam:  Model -> Html Msg
viewNewTeam model =
  if not model.newTeam then
   text ""
  else
   div [] [
     form [ method "POST", action "/users/sign_out" ] [
        input [ type_ "hidden", name "_method", value "delete" ] []
        , input [ type_ "hidden", name "authenticity_token", value model.formAuthenticityToken] []
        , input [ type_ "text", name "name", value ""] []
        , button [ name "button", type_ "submit", class "button" ] [ text "Save" ]
     ]

   ]


viewTeamFooter: Model -> Html Msg
viewTeamFooter model =
  div []
    [
      hr [] []
      , ul [ class "menu-list" ] [
        li []  [ a [ href "/teams" ] [ text "Account Setting" ] ]
        , li []  [ a [ href "/teams" ] [ text "Manage teams" ] ]
        , li []  [ a [ href "#", onClick NewTeam ] [ text "Add a new team" ] ]
        , li []  [
          form [ method "POST", action "/users/sign_out" ] [
            input [ type_ "hidden", name "_method", value "delete" ] []
            , input [ type_ "hidden", name "authenticity_token", value model.formAuthenticityToken] []
            , button [ name "button", type_ "submit", class "button" ] [ text "Logout" ]
          ]
        ]
      ]
    ]
