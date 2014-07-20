_ = require 'lodash'

dummyTour =
  'dummy':
    title: 'Hello guide!'
    text: '''
            This is a dummy guide step
          '''
    attachTo: 'body > *:first-child top'
    buttons: ['done']

module.exports = (Shepherd) ->

  class Tour
    name: 'tour'

    init: ->
      @model.setNull 'tour', dummyTour

    create: ->
      @start() if @model.get('autostart')

    start: ->
      @_createTour(@model.get 'tour')
      if startFromStep = @model.get('continue')
        @tour.show(startFromStep)
      else
        @tour.start()

    _createTour: (steps) ->
      @tour = new Shepherd.Tour
        defaults:
          classes: 'shepherd-theme-arrows'
          scrollTo: false

      for step, options of steps
        theOptions = _.cloneDeep(options)
        theOptions.buttons = for buttonType in options.buttons
          @_getTourButton(@tour, buttonType)
        @tour.addStep step, theOptions

      @tour.on 'start', ->
        $('html').addClass 'shepherd-active'

      @tour.on 'complete', =>
        @_completeShepherd()
        @emit 'complete'

      @tour

    _getTourButton: (tour, type) ->
      # You can add your custom buttons by extending the derby component
      # and adding _customButtons() method
      @_customButtons?(tour, type) ? switch type

        when 'back'
          text: 'Back'
          classes: 'shepherd-button-secondary'
          action: tour.back

        when 'exit'
          text: 'Exit'
          classes: 'shepherd-button-secondary'
          action: =>
            @completeShepherd()
            tour.hide()
            @emit 'complete'

        when 'done'
          text: 'Done'
          action: tour.next

        # Button that ends the part of tour on the current page
        when 'nextPage'
          text: 'Next'
          action: =>
            @completeShepherd()
            tour.hide()
            @emit 'sectionEnd'
            if nextPage = @model.get('nextPage')
              @app.history.push nextPage

        else
          text: 'Next'
          action: tour.next

    _completeShepherd: ->
      $('html').removeClass 'shepherd-active'
