module.exports = (app, options) ->
  isServer = app.derby.util.isServer

  app.component (require './tour/tour').apply this, isServer && [] ||
    [require('shepherd')]

  app.loadStyles __dirname + '/dist/styles'