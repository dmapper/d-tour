module.exports = (app, options) ->
  isServer = app.derby.util.isServer

  app.component (require './guide/guide').apply this, isServer && [] ||
    [require('shepherd')]

  app.loadStyles __dirname + '/dist/styles'