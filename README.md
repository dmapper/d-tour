# d-guide

> Guide plugin for Derby.js.
>
> Uses [Shepherd.js](http://github.hubspot.com/shepherd/docs/welcome/)



## Usage
```coffee
app.use require('local-d-guide')
```

```coffee
dummyTour =
  'first step':
    title: 'Hello guide!'
    text: '''
            This is a dummy guide step
          '''
    attachTo: 'body > *:first-child top'
    buttons: ['done']
```

```jade
view(name='guide', tour='{{dummyTour}}', autostart)
```

You can choose from 5 predefined buttons:

`next`, `back`, `done`, `exit`, `nextSection`


## Multi-page guide
You can create a guide which guides user through several pages:

1. Add `nextSection` button to the tour's step you want to be the last
    on the current page.
2. Add `nextUrl` argument to the guide component call in the view
    and provide the url that should be loaded next
3. On a new page add 'guide' component with the same tour and
    `continue` argument with the name of a step to start from.

### Example:

```coffee
multipageTour =

  'home step':
    title: 'first step!'
    text: '''
            I'm on first page
          '''
    attachTo: 'body > *:first-child top'
    buttons: ['exit', 'nextSection']

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
view(name='guide', tour='{{multipageTour}}', nextUrl='/about', autostart)
```

`/about` page:
```jade
view(name='guide', tour='{{multipageTour}}', continue='about step', autostart)
```