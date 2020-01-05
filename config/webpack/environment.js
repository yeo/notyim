const { environment } = require('@rails/webpacker')
const typescript =  require('./loaders/typescript')
const elm =  require('./loaders/elm')

environment.loaders.prepend('elm', elm)
environment.loaders.prepend('typescript', typescript)
module.exports = environment
