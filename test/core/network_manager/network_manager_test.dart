import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app_tdd_clean_arch/core/network_manager/network_manager.dart';

import 'network_manager_test.mocks.dart';

@GenerateMocks([DataConnectionChecker])
main() {
  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkManagerImpl networkManagerImpl;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkManagerImpl = NetworkManagerImpl(mockDataConnectionChecker);
  });

  test(
    'should call hasConnection',
    () async {
      // arrange
      when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
      // act
      await networkManagerImpl.isConnected;
      // assert
      verify(mockDataConnectionChecker.hasConnection);
    },
  );
}