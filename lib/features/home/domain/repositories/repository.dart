import 'package:dartz/dartz.dart';
import 'package:todo_app_tdd_clean_arch/core/entities/todo.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
}