import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosRepository _todosRepository;

  StatsBloc(this._todosRepository) : super(StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onSubscriptionRequested(
    StatsSubscriptionRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));

    await emit.forEach(
      _todosRepository.getTodos(),
      onData:
          (todos) => state.copyWith(
            status: StatsStatus.success,
            completedTodos: todos.where((todo) => todo.isCompleted).length,
            activeTodos: todos.where((todo) => !todo.isCompleted).length,
          ),
      onError: (_, _) => state.copyWith(status: StatsStatus.failure),
    );
  }
}
