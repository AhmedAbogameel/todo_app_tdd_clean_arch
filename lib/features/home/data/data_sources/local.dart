import 'package:todo_app_tdd_clean_arch/core/models/todo_model.dart';

abstract class HomeLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
}