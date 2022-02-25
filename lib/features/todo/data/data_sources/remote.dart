import 'package:todo_app_tdd_clean_arch/features/todo/data/models/todo_model.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<Todo> createTodo(Todo todo);
  Future<void> uploadUnsentTodos(List<TodoModel> todos);
}