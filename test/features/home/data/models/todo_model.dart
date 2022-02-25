import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/data/models/todo_model.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {

  final tTodoModel = TodoModel(dateTime: 'dateTime', content: 'content', uploaded: true);

  test(
    'should be subclass of Todo',
    () async {
      // assert
      expect(tTodoModel, isA<Todo>());
    },
  );

  test(
    'should get Todo Model when data is valid',
    () async {
      // arrange
      final jsonMap = fixture('success_todo');
      // act
      final model = TodoModel.fromJson(jsonMap);
      // assert
      expect(model, tTodoModel);
    },
  );

}