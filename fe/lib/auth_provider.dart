import 'package:fe/api.dart';
import 'package:flutter/material.dart';
import "./classes/get_user_class.dart";


class AuthState extends ChangeNotifier {

  User _user = const User();
  User get userInfo => _user;
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
  void logout(){
    _user = const User();
    notifyListeners();
  }
bool get isAuthorized {
  return _user.username.isNotEmpty;
}
  Future<bool> tryLogin(username) async {
    final user = await fetchUserByUsername(username);
    if (user != null) {
    _user = user;
    return true; // has a login record.
  }
  return false;
  }
}