import 'package:data_connection_checker_tv/data_connection_checker.dart';

abstract class NetworkManager {
  Future<bool> get isConnected;
}

class NetworkManagerImpl implements NetworkManager {

  final DataConnectionChecker dataConnectionChecker;
  NetworkManagerImpl(this.dataConnectionChecker);

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;

}