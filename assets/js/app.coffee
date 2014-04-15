
###
The main TodoMVC app module
@type {angular.Module}
###


angular.module('todomvc', ['ngRoute']).config ($routeProvider) ->
  $routeProvider.when('/',
    controller: 'TodoCtrl'
    templateUrl: 'templates/todomvc-index.html'
  # ).when('/:status',
  #   controller: 'TodoCtrl'
  #   templateUrl: 'templates/todomvc-index.html'
  ).otherwise redirectTo: '/'
  return
