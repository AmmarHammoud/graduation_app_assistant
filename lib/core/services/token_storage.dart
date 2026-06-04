import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  final _secure = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _secure.write(key: _kAccess, value: access);
    await _secure.write(key: _kRefresh, value: refresh);
  }

  Future<String?> readAccess() => _secure.read(key: _kAccess);
  Future<String?> readRefresh() => _secure.read(key: _kRefresh);

  Future<void> saveAccess(String access) =>
      _secure.write(key: _kAccess, value: access);
  Future<void> clear() async {
    await _secure.deleteAll();
  }
}
