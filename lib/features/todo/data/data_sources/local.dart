import 'package:todo_app_tdd_clean_arch/features/todo/data/models/todo_model.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';

abstract class TodoLocalDataSource {
  Future<void> updateTodo(Todo todo);
  Future<void> createTodo(Todo todo);
  Future<void> deleteTodo(Todo todo);
  Future<List<TodoModel>> getTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
}