import 'package:dartz/dartz.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/exceptions.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/core/network_manager/network_manager.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/data/data_sources/local.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/data/data_sources/remote.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/repositories/repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final NetworkManager networkManager;
  final TodoRemoteDataSource todoRemoteDataSource;
  final TodoLocalDataSource todoLocalDataSource;

  TodoRepositoryImpl({
    required this.networkManager,
    required this.todoRemoteDataSource,
    required this.todoLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    if (await networkManager.isConnected) {
      return _getTodosFromRemoteDS();
    } else {
      return _getTodosFromLocalDS();
    }
  }

  Future<Either<Failure, List<Todo>>> _getTodosFromRemoteDS() async {
    try {
      final result = await todoRemoteDataSource.getTodos();
      await todoLocalDataSource.cacheTodos(result);
      return Right(result);
    } on ServerException {
      return _getTodosFromLocalDS();
    }
  }

  Future<Either<Failure, List<Todo>>> _getTodosFromLocalDS() async {
    final result = await todoLocalDataSource.getTodos();
    return Right(result);
  }

  @override
  Future<Either<Failure, Todo>> createTodo(Todo todo) async {
    if (await networkManager.isConnected) {
      try {
        final result = await todoRemoteDataSource.createTodo(todo);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> deleteTodo(Todo todo) {
    // TODO: implement deleteTodos
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Todo>> updateTodo(Todo todo) {
    // TODO: implement updateTodos
    throw UnimplementedError();
  }

}
