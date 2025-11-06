import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn);
  }

  Future<void> ensureOnline() async {
    if (!await isOnline()) {
      throw NetworkException('No internet connection');
    }
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}
