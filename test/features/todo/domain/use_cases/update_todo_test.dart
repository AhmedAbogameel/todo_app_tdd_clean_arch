import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/use_cases/update_todo.dart';

import 'get_todos_test.mocks.dart';

main() {
  late UpdateTodo updateTodo;
  late MockTodoRepository mockTodoRepository;

  final tTodo = Todo(dateTime: 'dateTime', content: 'content', uploaded: true);

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    updateTodo = UpdateTodo(repository: mockTodoRepository);
  });

  test(
    'should call updateTodo from repos',
        () async {
      // arrange
      when(mockTodoRepository.updateTodo(tTodo)).thenAnswer((_) async => Right(tTodo));
      // act
      await updateTodo(tTodo);
      // assert
      verify(mockTodoRepository.updateTodo(tTodo));
    },
  );

  test(
    'should get Todo after update',
        () async {
      // arrange
      when(mockTodoRepository.updateTodo(tTodo)).thenAnswer((_) async => Right(tTodo));
      // act
      final result = await updateTodo(tTodo);
      // assert
      expect(result, Right(tTodo));
    },
  );

  test(
    'should throws a failure when data is invalid',
        () async {
      // arrange
      when(mockTodoRepository.updateTodo(tTodo)).thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await updateTodo(tTodo);
      // assert
      expect(result, Left(ServerFailure()));
    },
  );

}