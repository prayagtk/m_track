import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:m_track/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  Box<UserModel>? _userBox;
  static const String _loggedInKey = 'isLoggedIn';
  Future<void> openBox() async {
    _userBox = await Hive.openBox<UserModel>('users');
  }

  Future<bool> registerUser(UserModel user) async {
    if (_userBox == null) {
      await openBox();
    }

    await _userBox!.add(user);
    notifyListeners();
    print("Success");
    return true;
  }

  Future<UserModel?> loginUser(String email, String password) async {
    if (_userBox == null) {
      await openBox();
    }

    for (var user in _userBox!.values) {
      if (user.email == email && user.password == password) {
        await setloggedInStatus(true, user.id);
        return user;
      }
    }
    return null;
  }

  Future<void> setloggedInStatus(bool isLoggedIn, String userId) async {
    final _preference = await SharedPreferences.getInstance();
    await _preference.setBool(_loggedInKey, isLoggedIn);
    await _preference.setString('userId', userId);
  }

  Future<bool> isUserLoggedIn() async {
    final _preference = await SharedPreferences.getInstance();
    return _preference.getBool(_loggedInKey) ?? false;
  }

  Future<UserModel?> getCurrentUser() async {
    final isLoggedIn = await isUserLoggedIn();
    if (isLoggedIn) {
      final loggedInUserId = await getLoggedInUserId();

      for (var user in _userBox!.values) {
        if (user.id == loggedInUserId) {
          return user;
        }
      }
    }
    return null;
  }

  Future<String?> getLoggedInUserId() async {
    final _preference = await SharedPreferences.getInstance();
    final id = await _preference.getString('userId');
    return id;
  }
}
