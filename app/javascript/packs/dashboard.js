/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "core-js/stable";
import "regenerator-runtime/runtime";

require.context('../images', true);
import '../src/application.scss';
import * as Chartist from 'chartist';

// Stimulus
import "../controllers"

import { Elm as AssertEditor } from '../AssertEditor';
import { Elm as TeamPicker } from '../TeamPicker'


window.Chartist = Chartist;

if (typeof window.Elm  === "undefined") {
  window.Elm = {}
}

window.Elm.AssertEditor = AssertEditor.AssertEditor
window.Elm.TeamPicker = TeamPicker.TeamPicker
