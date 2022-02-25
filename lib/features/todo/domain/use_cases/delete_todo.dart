import 'package:dartz/dartz.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/repositories/repository.dart';

class DeleteTodo {

  final TodoRepository repository;

  DeleteTodo({required this.repository});

  Future<Either<Failure, Todo>> call(Todo todo) => repository.deleteTodo(todo);

}