import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
import 'package:todo_app_tdd_clean_arch/features/home/domain/use_cases/upload_un_send_todos.dart';

import 'get_todos_test.mocks.dart';

main() {
  late MockHomeRepository mockHomeRepository;
  late UploadUnSendTodos uploadUnSendTodos;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    uploadUnSendTodos = UploadUnSendTodos(repository: mockHomeRepository);
  });

  test(
    'should upload un send todos from Local DS to Remote DS',
    () async {
      // arrange
      when(mockHomeRepository.uploadUnSendTodos()).thenAnswer((_) async => Right(Void));
      // act
      final result = await uploadUnSendTodos();
      // assert
      expect(result, Right(Void));
    },
  );

  test(
    'should return Failure when failing to upload data',
    () async {
      // arrange
      when(mockHomeRepository.uploadUnSendTodos()).thenAnswer((_) async => Left(UploadFailure()));
      // act
      final result = await uploadUnSendTodos();
      // assert
      expect(result, Left(UploadFailure()));
    },
  );
}