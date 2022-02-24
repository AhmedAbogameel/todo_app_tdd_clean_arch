import 'package:todo_app_tdd_clean_arch/core/models/todo_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> uploadUnSendTodos();
}