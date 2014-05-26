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

  class Guide
    name: 'guide'

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

        # Button that ends the part of guide on the current page
        # To create a multi-page guide:
        # 1. Add 'nextSection' button to the tour's step you want to be the last
        #     on the current page.
        # 2. Add 'nextUrl' argument to the guide component call in the view
        #     and provide the url that should be loaded next
        # 3. On a new page add 'guide' component with the same tour and
        #     'continue' argument with the name of a step to start from.
        when 'nextSection'
          text: 'Next'
          action: =>
            @completeShepherd()
            tour.hide()
            @emit 'sectionEnd'
            if nextPage = @model.get('nextUrl')
              @app.history.push nextPage

        else
          text: 'Next'
          action: tour.next

    _completeShepherd: ->
      $('html').removeClass 'shepherd-active'
