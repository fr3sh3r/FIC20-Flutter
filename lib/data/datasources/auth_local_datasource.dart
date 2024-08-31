import 'package:flutter_hrm_inventory_pos_app/data/models/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  //saveAuthData
  Future<void> saveAuthData(AuthResponseModel authResponseModel) async {
    //save auth data to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_data', authResponseModel.toJson());
  }

  //removeAuthData
  Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }

  //getAuthData
  Future<AuthResponseModel> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');

    return AuthResponseModel.fromJson(authData!);
  }

  //isUserLoggedIn
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_data');
  }

  //getUser
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final authData = prefs.getString('auth_data');
    final authResponseModel = AuthResponseModel.fromJson(authData!);

    return authResponseModel.user!;
  }
}

