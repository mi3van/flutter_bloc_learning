part of 'todos_overview_bloc.dart';

sealed class TodosOverviewEvent extends Equatable {
  const TodosOverviewEvent();

  @override
  List<Object> get props => [];
}

final class TodosOverviewSubscriptionRequested extends TodosOverviewEvent {
  const TodosOverviewSubscriptionRequested();
}

final class TodosOverviewCompletionToggled extends TodosOverviewEvent {
  final Todo todo;
  final bool isCompleted;

  const TodosOverviewCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [todo, isCompleted];
}

final class TodosOverviewTodoDeleted extends TodosOverviewEvent {
  final Todo todo;

  const TodosOverviewTodoDeleted(this.todo);

  @override
  List<Object> get props => [todo];
}

final class TodosOverviewUndoDeletionRequested extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequested();
}

final class TodosOverviewFilterChanged extends TodosOverviewEvent {
  const TodosOverviewFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class TodosOverviewToggleAllRequested extends TodosOverviewEvent {
  const TodosOverviewToggleAllRequested();
}

class TodosOverviewClearCompletedRequested extends TodosOverviewEvent {
  const TodosOverviewClearCompletedRequested();
}
