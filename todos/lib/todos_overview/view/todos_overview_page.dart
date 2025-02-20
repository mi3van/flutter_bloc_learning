import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/view/edit_todo_page.dart';
import 'package:flutter_todos/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:flutter_todos/todos_overview/widgets/todo_list_tile.dart';
import 'package:flutter_todos/todos_overview/widgets/todos_overview_filter_button.dart';
import 'package:flutter_todos/todos_overview/widgets/todos_overview_options_button.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return TodosOverviewBloc(context.read<TodosRepository>())
          ..add(TodosOverviewSubscriptionRequested());
      },
      child: TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todosOverviewAppBarTitle'),
        actions: const [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen:
                (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('todosOverviewErrorSnackbarText')),
                  );
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen:
                (previous, current) =>
                    previous.lastDeletedTodo != current.lastDeletedTodo &&
                    current.lastDeletedTodo != null,
            listener: (context, state) {
              final todo = state.lastDeletedTodo!;

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      'todosOverviewTodoDeletedSnackbarText ${todo.title}',
                    ),
                    action: SnackBarAction(
                      label: 'todosOverviewUndoDeletionButtonText',
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        context.read<TodosOverviewBloc>().add(
                          const TodosOverviewUndoDeletionRequested(),
                        );
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    'todosOverviewEmptyText',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView.builder(
                itemCount: state.filteredTodos.length,
                itemBuilder: (_, index) {
                  final todo = state.filteredTodos.elementAt(index);
                  return TodoListTile(
                    todo: todo,
                    onToggleCompleted: (isCompleted) {
                      context.read<TodosOverviewBloc>().add(
                        TodosOverviewCompletionToggled(
                          todo: todo,
                          isCompleted: isCompleted,
                        ),
                      );
                    },
                    onDismissed: (_) {
                      context.read<TodosOverviewBloc>().add(
                        TodosOverviewTodoDeleted(todo),
                      );
                    },
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(EditTodoPage.route(initialTodo: todo));
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
