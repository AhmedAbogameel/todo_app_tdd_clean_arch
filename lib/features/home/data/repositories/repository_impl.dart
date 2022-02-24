import 'package:dartz/dartz.dart';
import 'package:todo_app_tdd_clean_arch/core/entities/todo.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/exceptions.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/core/network_manager/network_manager.dart';
import 'package:todo_app_tdd_clean_arch/features/home/data/data_sources/local.dart';
import 'package:todo_app_tdd_clean_arch/features/home/data/data_sources/remote.dart';
import 'package:todo_app_tdd_clean_arch/features/home/domain/repositories/repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final NetworkManager networkManager;
  final HomeRemoteDataSource homeRemoteDataSource;
  final HomeLocalDataSource homeLocalDataSource;

  HomeRepositoryImpl({
    required this.networkManager,
    required this.homeRemoteDataSource,
    required this.homeLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    if (await networkManager.isConnected) {
      try {
        final result = await homeRemoteDataSource.getTodos();
        await homeLocalDataSource.cacheTodos(result);
        return Right(result);
      } on ServerException {
        return _getTodosFromLocalDS();
      }
    } else {
      return _getTodosFromLocalDS();
    }
  }

  Future<Either<Failure, List<Todo>>> _getTodosFromLocalDS() async {
    final result = await homeLocalDataSource.getTodos();
    return Right(result);
  }

}
