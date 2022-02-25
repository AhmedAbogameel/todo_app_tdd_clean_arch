import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/entities/todo.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/repositories/repository.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/domain/use_cases/get_todos.dart';

import 'get_todos_test.mocks.dart';


@GenerateMocks([TodoRepository])
main() {
  late MockTodoRepository mockHomeRepository;
  late GetTodos getTodos;

  final tTodos = [
    Todo(dateTime: 'dateTime', content: 'content', uploaded: true),
  ];

  setUp(() {
    mockHomeRepository = MockTodoRepository();
    getTodos = GetTodos(repository: mockHomeRepository);
  });

  test(
    'should get List<Todos> from repository',
    () async {
      // arrange
      when(mockHomeRepository.getTodos()).thenAnswer((_) async => Right(tTodos));
      // act
      final result = await getTodos();
      // assert
      expect(result, Right(tTodos));
    },
  );

  test(
    'should get Failure when data is not available',
    () async {
      // arrange
      when(mockHomeRepository.getTodos()).thenAnswer((_) async => Left(CacheFailure()));
      // act
      final result = await mockHomeRepository.getTodos();
      // assert
      expect(result, Left(CacheFailure()));
    },
  );

}