import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/use_cases/create_todo.dart';

import 'get_todos_test.mocks.dart';

main() {
  late CreateTodo createTodo;
  late MockTodoRepository mockTodoRepository;

  final tTodo = Todo(dateTime: 'dateTime', content: 'content', uploaded: true);

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    createTodo = CreateTodo(repository: mockTodoRepository);
  });

  test(
    'should call createTodo from repos',
    () async {
      // arrange
      when(mockTodoRepository.createTodo(tTodo)).thenAnswer((_) async => Right(tTodo));
      // act
      await createTodo(tTodo);
      // assert
      verify(mockTodoRepository.createTodo(tTodo));
    },
  );

  test(
    'should get Todo after creation',
    () async {
      // arrange
      when(mockTodoRepository.createTodo(tTodo)).thenAnswer((_) async => Right(tTodo));
      // act
      final result = await createTodo(tTodo);
      // assert
      expect(result, Right(tTodo));
    },
  );

  test(
    'should throws a failure when data is invalid',
    () async {
      // arrange
      when(mockTodoRepository.createTodo(tTodo)).thenAnswer((_) async => Left(ServerFailure()));
      // act
      final result = await createTodo(tTodo);
      // assert
      expect(result, Left(ServerFailure()));
    },
  );

}