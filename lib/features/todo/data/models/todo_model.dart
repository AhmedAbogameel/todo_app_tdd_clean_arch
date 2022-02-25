import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required String dateTime,
    required String content,
    required bool uploaded,
  }) : super(
          content: content,
          dateTime: dateTime,
          uploaded: uploaded,
        );

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        dateTime: json['dateTime'].toString(),
        content: json['content'],
        uploaded: json['uploaded'],
      );

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime,
        'content': content,
        'uploaded': uploaded,
      };
}
