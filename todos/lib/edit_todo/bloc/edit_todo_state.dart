part of 'edit_todo_bloc.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusExt on EditTodoStatus {
  bool get isLoadingOrSuccess =>
      [EditTodoStatus.loading, EditTodoStatus.success].contains(this);
}

final class EditTodoState extends Equatable {
  final EditTodoStatus status;
  final Todo? initialTodo;
  final String title;
  final String description;

  const EditTodoState({
    this.status = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
    this.description = '',
  });

  EditTodoState copyWith({
    EditTodoStatus? status,
    Todo? initialTodo,
    String? title,
    String? description,
  }) {
    return EditTodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  bool get isNewTodo => initialTodo == null;

  @override
  List<Object?> get props => [status, initialTodo, title, description];
}
