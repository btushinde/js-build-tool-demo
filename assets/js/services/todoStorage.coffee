#global angular

###
Services that persists and retrieves TODOs from localStorage
###
angular.module("todomvc").factory "todoStorage", ->
  "use strict"
  STORAGE_ID = "todos-angularjs"
  get: ->
    JSON.parse localStorage.getItem(STORAGE_ID) or "[]"

  put: (todos) ->
    localStorage.setItem STORAGE_ID, JSON.stringify(todos)
    return
