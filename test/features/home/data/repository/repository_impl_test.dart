import 'dart:ffi';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app_tdd_clean_arch/core/errors/exceptions.dart';
import 'package:todo_app_tdd_clean_arch/core/models/todo_model.dart';
import 'package:todo_app_tdd_clean_arch/core/network_manager/network_manager.dart';
import 'package:todo_app_tdd_clean_arch/features/home/data/data_sources/local.dart';
import 'package:todo_app_tdd_clean_arch/features/home/data/data_sources/remote.dart';
import 'package:todo_app_tdd_clean_arch/features/home/data/repositories/repository_impl.dart';
import 'repository_impl_test.mocks.dart';

@GenerateMocks([HomeRemoteDataSource, HomeLocalDataSource, NetworkManager])
main() {
  late MockHomeRemoteDataSource mockHomeRemoteDataSource;
  late MockNetworkManager mockNetworkManager;
  late MockHomeLocalDataSource mockHomeLocalDataSource;
  late HomeRepositoryImpl homeRepositoryImpl;

  final tTodos = [
    TodoModel(
      dateTime: 'dateTime',
      content: 'content',
      uploaded: true,
    ),
  ];

  setUp(() {
    mockHomeLocalDataSource = MockHomeLocalDataSource();
    mockHomeRemoteDataSource = MockHomeRemoteDataSource();
    mockNetworkManager = MockNetworkManager();
    homeRepositoryImpl = HomeRepositoryImpl(
      networkManager: mockNetworkManager,
      homeRemoteDataSource: mockHomeRemoteDataSource,
      homeLocalDataSource: mockHomeLocalDataSource,
    );
  });

  group('Device is Online', () {
    test(
      'should repository call isConnected',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => true);
        when(mockHomeRemoteDataSource.getTodos()).thenAnswer((_) async => tTodos);
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
        when(mockHomeRemoteDataSource.getTodos()).thenAnswer((_) async => tTodos);
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
        when(mockHomeRemoteDataSource.getTodos()).thenAnswer((_) async => tTodos);
        when(mockHomeLocalDataSource.cacheTodos(any)).thenAnswer((_) async => Void);
        // act
        await homeRepositoryImpl.getTodos();
        // assert
        verify(mockHomeLocalDataSource.cacheTodos(tTodos));
      },
    );

    test(
      'should get todos from local DS when throws a Server Exception when data is invalid',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => true);
        when(mockHomeRemoteDataSource.getTodos()).thenThrow(ServerException());
        when(mockHomeLocalDataSource.getTodos()).thenAnswer((_) async => tTodos);
        // act
        final result = await homeRepositoryImpl.getTodos();
        // assert
        expect(result, Right(tTodos));
        verify(mockHomeLocalDataSource.getTodos());
      },
    );
  });

  group('Device is Offline', () {
    test(
      'should get data from local DS',
      () async {
        // arrange
        when(mockNetworkManager.isConnected).thenAnswer((_) async => false);
        when(mockHomeLocalDataSource.getTodos()).thenAnswer((_) async => tTodos);
        // act
        final result = await homeRepositoryImpl.getTodos();
        // assert
        expect(result, Right(tTodos));
        verifyZeroInteractions(mockHomeRemoteDataSource);
      },
    );
  });
}
