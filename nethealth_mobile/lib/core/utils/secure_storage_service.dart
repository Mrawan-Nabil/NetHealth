import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class SecureStorageService {
  SecureStorageService._();

  static final SecureStorageService instance = SecureStorageService._();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> writeToken(String token) =>
      _storage.write(key: AppConstants.tokenKey, value: token);

  Future<String?> readToken() =>
      _storage.read(key: AppConstants.tokenKey);

  Future<void> deleteToken() =>
      _storage.delete(key: AppConstants.tokenKey);

  Future<void> writeUser(String userJson) =>
      _storage.write(key: AppConstants.userKey, value: userJson);

  Future<String?> readUser() =>
      _storage.read(key: AppConstants.userKey);

  Future<void> deleteUser() =>
      _storage.delete(key: AppConstants.userKey);

  Future<void> clearAll() => _storage.deleteAll();
}
