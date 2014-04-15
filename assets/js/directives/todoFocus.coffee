#global angular

###
Directive that places focus on the element it is applied to when the
expression it binds to evaluates to true
###
angular.module("todomvc").directive "todoFocus", todoFocus = ($timeout) ->
  (scope, elem, attrs) ->
    scope.$watch attrs.todoFocus, (newVal) ->
      if newVal
        $timeout (->
          elem[0].focus()
          return
        ), 0, false
      return

    return
