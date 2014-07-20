# d-tour

> Tour guide plugin for Derby.js
>
> Uses [Shepherd.js](http://github.hubspot.com/shepherd/docs/welcome/)


## Usage
```coffee
app.use require('d-tour')
```

```coffee
dummyTour =
  'first step':
    title: 'Hello tour!'
    text: '''
            This is a dummy tour step
          '''
    attachTo: 'body > *:first-child top'
    buttons: ['done']
```

```jade
view(name='tour', tour='{{dummyTour}}', autostart)
```

You can choose from 5 predefined buttons:

`next`, `back`, `done`, `exit`, `nextSection`


## Autostart and Manual tour start

Providing `autostart` argument tells tour to start right after component renders. 
If you rather want to start tour manually just run its `start()` method:

```jade
view(name='tour', as='tour', tour='{{dummyTour}}')
button(on-click='tour.start()') Start guide!
```


## Multi-page tour
You can create a tour which guides user through several pages:

1. Add `nextPage` button to the tour's step you want to be the last
    on the current page.
2. Add `nextPage` argument to the `tour` component call in the view
    and provide the url that should be loaded next
3. On a new page add `tour` component with the same tour and
    `startFrom` argument with the name of a step to start from.

### Example:

```coffee
multipageTour =

  'home step':
    title: 'first step!'
    text: '''
            I'm on first page
          '''
    attachTo: 'body > *:first-child top'
    buttons: ['exit', 'nextPage']

  'about step':
    title: 'second step!'
    text: '''
            I'm on second page
          '''
    attachTo: 'body > *:first-child top'
    buttons: ['back', 'done']

```

`/home` page:
```jade
view(name='tour', tour='{{multipageTour}}', nextPage='/about', autostart)
```

`/about` page:
```jade
view(name='tour', tour='{{multipageTour}}', startFrom='about step', autostart)
```