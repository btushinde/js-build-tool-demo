#global angular

###
Directive that executes an expression when the element it is applied to gets
an `escape` keydown event.
###
angular.module("todomvc").directive "todoEscape", ->
  "use strict"
  ESCAPE_KEY = 27
  (scope, elem, attrs) ->
    elem.bind "keydown", (event) ->
      scope.$apply attrs.todoEscape  if event.keyCode is ESCAPE_KEY
      return

    return
