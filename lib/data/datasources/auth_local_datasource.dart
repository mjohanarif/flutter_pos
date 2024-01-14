import 'package:flutter_pos/data/model/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  Future<void> saveAuthData(AuthResponseModel authResponseModel) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'auth_data',
      authResponseModel.toRawJson(),
    );
  }

  Future<void> remoteAuthData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      'auth_data',
    );
  }

  Future<AuthResponseModel> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');

    return AuthResponseModel.fromRawJson(authData!);
  }

  Future<bool> isAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');

    return authData != null;
  }

  Future<void> saveMidtransServerKey(String serverKey) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'server_key',
      serverKey,
    );
  }

  Future<String> getMidtransServerKey() async {
    final prefs = await SharedPreferences.getInstance();

    final serverKey = prefs.getString(
      'server_key',
    );

    return serverKey ?? '';
  }
}
