import 'package:dartz/dartz.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/core/entities/todo.dart';
import 'package:todo_app_tdd_clean_arch/features/home/domain/repositories/repository.dart';

class GetTodos {

  final HomeRepository repository;

  GetTodos({required this.repository});

  Future<Either<Failure, List<Todo>>> call() => repository.getTodos();
}