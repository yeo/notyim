//Switch to using CommonJS
//https://github.com/reactjs/react-rails/issues/413
//Sample app: https://github.com/gauravtiwari/browserify_on_rails
//const ReactDOMServer = window.ReactDOMServer = global.ReactDOMServer = require('react-dom/server')

//import Check from './components/check.es6.js'
//import Checkout from './components/checkout.es6.js'
//import TeamPicker from './components/shared/_team_picker.es6.js'
import {AssertEditor} from './components/AssertEditor.js'
import {TeamPicker} from './components/TeamPicker.js'

// Global namespace, accessiable from anywhere to hold those ReactComponent
// because we expose those via Sprocket
const app = window.app = global.app = {}
//app.Check = Check
//app.Checkout = Checkout
app.AssertEditor = AssertEditor
app.TeamPicker = TeamPicker
