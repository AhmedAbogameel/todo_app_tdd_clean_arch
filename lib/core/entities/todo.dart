import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String dateTime;
  final String content;
  final bool uploaded;

  const Todo(
      {required this.dateTime, required this.content, required this.uploaded});

  @override
  List<Object?> get props => [
        dateTime,
        content,
        uploaded,
      ];
}
