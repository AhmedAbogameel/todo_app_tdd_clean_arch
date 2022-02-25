import 'package:todo_app_tdd_clean_arch/features/todo/data/models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> uploadUnsentTodos(List<TodoModel> todos);
}