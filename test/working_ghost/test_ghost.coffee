phantom.test.root = "http://127.0.0.1:4567"

phantom.test.add "Simple index", ->
  @get '/', ->
    @body.assertFirst 'p', (p) ->
      p.innerHTML == 'This is my paragraph'
    @body.assertAll 'ul li', (li, idx) ->
      li.innerHTML == "List item #{idx + 1}"
    @body.assertCountAndAll 'a', 2, (a, idx) ->
      if idx == 0
        a.href == 'http://127.0.0.1:4567/form'
      else if idx == 1
        a.href == 'javascript:%20false;'
    @succeed()

phantom.test.add "Simple slow index", ->
  @get '/slow-index', total: 3, ->
    @succeed()

phantom.test.add "Form input", ->
  @get '/form', ->
    @body.input "#in", "this is my input"
    @body.click "#btn"
    @body.assertFirst '#out', (out) ->
      out.innerHTML == 'this is my input'
    @succeed()

phantom.test.add "Select box input", ->
  @get '/form', ->
    @body.select "#sel", "test3"
    @body.assertFirst '#out', (out) ->
      out.innerHTML == 'test3'
    @succeed()

phantom.test.add "Link traversal", ->
  @get '/', ->
    @body.click 'a'
    @body.assertLocation('/form')
    @succeed()

phantom.test.add "Link traversal with counter-case", ->
  @get '/', ->
    @body.click 'a'
    @body.refuteLocation('/')
    @succeed()

phantom.test.add "Click follow", ->
  @get '/', ->
    @body.clickFollow 'a'
    @succeed()

phantom.test.add "Click follow with positive case", ->
  @get '/', ->
    @body.clickFollow 'a', path: "/form"
    @succeed()

phantom.test.add "Function assertion", ->
  @get '/', ->
    @body.assertFunction ->
      test1 = 'foo'                 # usage of '' and "" ok
      test2 = "afoo".substr 1, 3
      test1 == test2                # return bool
    @body.assertFunction -> 2 + 3   # return non-0-number
    @body.assertFunction -> {}      # return object
    @body.assertFunction -> []      # return array
    @succeed()
