// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
// require_self
//= require react_ujs
//= require components
// NPM Modules
//= require chartist/dist/chartist.min
// require_tree .

// https://github.com/reactjs/react-rails/issues/413
//var React = window.React = global.React = require('react')
//var ReactDOM= window.ReactDOM = global.ReactDOM = require('react-dom')
window.$ = window.jQuery = require('jquery')
require('jquery-ujs')
require('./common')
