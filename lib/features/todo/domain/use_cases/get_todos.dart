import 'package:dartz/dartz.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/repositories/repository.dart';

class GetTodos {

  final TodoRepository repository;

  GetTodos({required this.repository});

  Future<Either<Failure, List<Todo>>> call() => repository.getTodos();
}