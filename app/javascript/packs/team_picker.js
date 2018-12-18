import {
  Elm
}from '../TeamPicker'

if (typeof window.Elm  === "undefined") {
  window.Elm = Elm
}

window.Elm.TeamPicker = Elm.TeamPicker
