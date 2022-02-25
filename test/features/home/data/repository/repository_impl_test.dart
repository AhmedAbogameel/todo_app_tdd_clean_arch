import 'dart:ffi';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/exceptions.dart';
import 'package:todo_app_tdd_clean_arch/core/network_manager/network_manager.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/data/data_sources/local.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/data/data_sources/remote.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/data/models/todo_model.dart';
import 'package:todo_app_tdd_clean_arch/features/todo/data/repositories/repository_impl.dart';
import 'repository_impl_test.mocks.dart';

@GenerateMocks([TodoRemoteDataSource, TodoLocalDataSource, NetworkManager])
main() {
  late MockTodoRemoteDataSource mockTodoRemoteDataSource;
  late MockNetworkManager mockNetworkManager;
  late MockTodoLocalDataSource mockTodoLocalDataSource;
  late TodoRepositoryImpl homeRepositoryImpl;

  final tTodos = [
    TodoModel(
      dateTime: 'dateTime',
      content: 'content',
      uploaded: true,
    ),
  ];

  setUp(() {
    mockTodoLocalDataSource = MockTodoLocalDataSource();
    mockTodoRemoteDataSource = MockTodoRemoteDataSource();
    mockNetworkManager = MockNetworkManager();
    homeRepositoryImpl = TodoRepositoryImpl(
      networkManager: mockNetworkManager,
      todoRemoteDataSource: mockTodoRemoteDataSource,
      todoLocalDataSource: mockTodoLocalDataSource,
    );
  });

  group('Device is Online', () {
    test(
      'should repository call isConnected',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => true);
        when(mockTodoRemoteDataSource.getTodos()).thenAnswer((_) async => tTodos);
        // act
        homeRepositoryImpl.getTodos();
        // assert
        verify(mockNetworkManager.isConnected);
      },
    );

    test(
      'should get List of TodoModel when data is valid',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => true);
        when(mockTodoRemoteDataSource.getTodos()).thenAnswer((_) async => tTodos);
        // act
        final result = await homeRepositoryImpl.getTodos();
        // assert
        expect(result, Right(tTodos));
      },
    );

    test(
      'should call local DS to cache data',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => true);
        when(mockTodoRemoteDataSource.getTodos()).thenAnswer((_) async => tTodos);
        when(mockTodoLocalDataSource.cacheTodos(any)).thenAnswer((_) async => Void);
        // act
        await homeRepositoryImpl.getTodos();
        // assert
        verify(mockTodoLocalDataSource.cacheTodos(tTodos));
      },
    );

    test(
      'should get todos from local DS when throws a Server Exception when data is invalid',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => true);
        when(mockTodoRemoteDataSource.getTodos()).thenThrow(ServerException());
        when(mockTodoLocalDataSource.getTodos()).thenAnswer((_) async => tTodos);
        // act
        final result = await homeRepositoryImpl.getTodos();
        // assert
        expect(result, Right(tTodos));
        verify(mockTodoLocalDataSource.getTodos());
      },
    );
  });

  group('Device is Offline', () {
    test(
      'should get data from local DS',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => false);
        when(mockTodoLocalDataSource.getTodos()).thenAnswer((_) async => tTodos);
        // act
        final result = await homeRepositoryImpl.getTodos();
        // assert
        expect(result, Right(tTodos));
        verifyZeroInteractions(mockTodoRemoteDataSource);
      },
    );
  });
}
