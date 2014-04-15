#global angular

###
The main controller for the app. The controller:
- retrieves and persists the model via the todoStorage service
- exposes the model to the template and provides event handlers
###
angular.module("todomvc").controller "TodoCtrl", TodoCtrl = ($scope, $routeParams, $filter, todoStorage) ->
  todos = $scope.todos = todoStorage.get()
  $scope.newTodo = ""
  $scope.editedTodo = null
  $scope.$watch "todos", ((newValue, oldValue) ->
    $scope.remainingCount = $filter("filter")(todos,
      completed: false
    ).length
    $scope.completedCount = todos.length - $scope.remainingCount
    $scope.allChecked = not $scope.remainingCount
    # This prevents unneeded calls to the local storage
    todoStorage.put todos  if newValue isnt oldValue
    return
  ), true

  # Monitor the current route for changes and adjust the filter accordingly.
  $scope.$on "$routeChangeSuccess", ->
    status = $scope.status = $routeParams.status or ""
    $scope.statusFilter = (if (status is "active") then completed: false else (if (status is "completed") then completed: true else null))
    return

  $scope.addTodo = ->
    newTodo = $scope.newTodo.trim()
    return  unless newTodo.length
    todos.push
      title: newTodo
      completed: false

    $scope.newTodo = ""
    return

  $scope.editTodo = (todo) ->
    $scope.editedTodo = todo

    # Clone the original todo to restore it on demand.
    $scope.originalTodo = angular.extend({}, todo)
    return

  $scope.doneEditing = (todo) ->
    $scope.editedTodo = null
    todo.title = todo.title.trim()
    $scope.removeTodo todo  unless todo.title
    return

  $scope.revertEditing = (todo) ->
    todos[todos.indexOf(todo)] = $scope.originalTodo
    $scope.doneEditing $scope.originalTodo
    return

  $scope.removeTodo = (todo) ->
    todos.splice todos.indexOf(todo), 1
    return

  $scope.clearCompletedTodos = ->
    $scope.todos = todos = todos.filter((val) ->
      not val.completed
    )
    return

  $scope.markAll = (completed) ->
    todos.forEach (todo) ->
      todo.completed = not completed
      return

    return

  return
