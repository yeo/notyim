port module TeamPicker exposing (..)

import Browser exposing (element)
import Html exposing (Html, Attribute, div, button, a, hr, text, h2, p, label, select, option, span, input,ul, li, nav, form)
import Html.Attributes exposing (class, placeholder, type_, size, value, selected, name, disabled, href, method, action)
import Html.Events exposing (onClick, onInput)
import String
import Debug

main =
  element
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
  | NewTeam Bool
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
    NewTeam toggleFlag ->
        --Debug.log new_team
        ({model | newTeam = toggleFlag }, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "navbar-item teampicker" ]
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
          ]
       else
         text "")
    ]

viewTeamList : Model -> Html Msg
viewTeamList model =
  div [ class "menu" ] [
    p [ class "menu-label" ] [ text "Switch team" ]
    , ul [ class "menu-list" ] (List.map (\(team) -> li [] [
                                   case List.head model.teams of
                                     Nothing -> text ""
                                     Just defaultTeam ->
                                       if team.id == defaultTeam.id then
                                         span [] [ a [ href ("//" ++ model.domain ++ "/dashboard") ] [ text team.name ] ]
                                       else
                                         span [] [ a [ href ("//team-" ++ team.id ++ "." ++ model.domain ++ "/dashboard") ] [text team.name] ]

--                                   let
--                                       defaultTeam = List.head model.teams
--                                   in
--                                     if team.id == defaultTeam.id then
--                                       span [] [ a [ href (model.domain ++ "/dashboard") ] [ text team.name ] ]
--                                     else
--                                       span [] [ a [ href ("//team-" ++ team.id ++ "." ++ model.domain ++ "/dashboard") ] [text team.name] ]
--
                                   ]) model.teams)
  ]

viewNewTeam:  Model -> Html Msg
viewNewTeam model =
  if not model.newTeam then
   text ""
  else
   li [] [
     form [ method "POST", action "/teams" ] [
        input [ type_ "hidden", name "authenticity_token", value model.formAuthenticityToken] []
        , div [ class "field" ] [
            p [ class "control" ] [ input [ class "input", type_ "text", name "team[name]", value "", placeholder "Your Team"] [] ]
          ]
        , div [ class "field has-text-centered is-grouped" ] [
            p [ class "control" ] [
              button [ name "button", type_ "submit", class "button is-primary" ] [ text "Save" ]
            ]
            ,p [ class "control is-link" ] [
              a [ onClick (NewTeam False), class "button is-link" ] [ text "Cancel" ]
            ]
          ]
     ]

   ]


viewTeamFooter: Model -> Html Msg
viewTeamFooter model =
  div []
    [
      hr [] []
      , ul [ class "menu-list" ] [
        li []  [ a [ href "/users/edit" ] [ text "Account Setting" ] ]
        , li []  [ a [ href "/teams" ] [ text "Manage teams" ] ]
        , li []  [ a [ href "#", onClick (NewTeam True) ] [ text "Add a new team" ] ]
        , viewNewTeam model
        , li []  [
          form [ method "POST", action "/users/sign_out" ] [
            input [ type_ "hidden", name "_method", value "delete" ] []
            , input [ type_ "hidden", name "authenticity_token", value model.formAuthenticityToken] []
            , button [ name "button", type_ "submit", class "button" ] [ text "Logout" ]
          ]
        ]
      ]
    ]
