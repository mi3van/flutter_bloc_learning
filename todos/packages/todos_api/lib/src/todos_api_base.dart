import 'package:todos_api/src/models/todo.dart';

abstract interface class TodosApi {
  Stream<List<Todo>> getTodos();

  Future<void> saveTodo(Todo todo);

  /// If no `todo` with the given id exists, a [TodoNotFoundException] error is
  /// thrown.
  Future<void> deleteTodo(String id);

  /// Deletes all completed todos.
  ///
  /// Returns the number of deleted todos.
  Future<int> clearCompleted();

  /// Sets the `isCompleted` state of all todos to the given value.
  ///
  /// Returns the number of updated todos.
  Future<int> completeAll({required bool isCompleted});

  /// Closes the client and frees up any resources.
  Future<void> close();
}

/// Error thrown when a [Todo] with a given id is not found.
class TodoNotFoundException implements Exception {}
