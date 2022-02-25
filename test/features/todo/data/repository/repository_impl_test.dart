import 'dart:ffi';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/exceptions.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/failures.dart';
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
  late TodoRepositoryImpl todoRepositoryImpl;

  final tTodos = [
    TodoModel(
      dateTime: 'dateTime',
      content: 'content',
      uploaded: true,
    ),
  ];

  final tTodo = TodoModel(
    dateTime: 'dateTime',
    content: 'content',
    uploaded: true,
  );

  setUp(() {
    mockTodoLocalDataSource = MockTodoLocalDataSource();
    mockTodoRemoteDataSource = MockTodoRemoteDataSource();
    mockNetworkManager = MockNetworkManager();
    todoRepositoryImpl = TodoRepositoryImpl(
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
        todoRepositoryImpl.getTodos();
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
        final result = await todoRepositoryImpl.getTodos();
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
        await todoRepositoryImpl.getTodos();
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
        final result = await todoRepositoryImpl.getTodos();
        // assert
        expect(result, Right(tTodos));
        verify(mockTodoLocalDataSource.getTodos());
      },
    );

    test(
      'should create Todo when device is online',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => true);
        when(mockTodoRemoteDataSource.createTodo(tTodo)).thenAnswer((_) async => tTodo);
        // act
        final result = await todoRepositoryImpl.createTodo(tTodo);
        // assert
        expect(result, Right(tTodo));
      },
    );

    test(
      'should throws ServerFailure when Creation Failed',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => true);
        when(mockTodoRemoteDataSource.createTodo(tTodo)).thenThrow(ServerException());
        // act
        final result = await todoRepositoryImpl.createTodo(tTodo);
        // assert
        expect(result, Left(ServerFailure()));
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
        final result = await todoRepositoryImpl.getTodos();
        // assert
        expect(result, Right(tTodos));
        verifyZeroInteractions(mockTodoRemoteDataSource);
      },
    );

    test(
      'should throw NoConnectionFailure',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => false);
        // act
        final result = await todoRepositoryImpl.createTodo(tTodo);
        // assert
        verifyZeroInteractions(mockTodoRemoteDataSource);
        expect(result, Left(NoConnectionFailure()));
      },
    );
  });
}
