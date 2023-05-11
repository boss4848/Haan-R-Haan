import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class UserViewModels extends ChangeNotifier {
  //User
  UserModel _user = UserModel.empty();
  final UserService _userService = UserService();
  String _currentUserId = '';
  String get userID => _currentUserId;
  UserModel get user => _user;

  //Party

  Future<void> init() async {
    try {
      _currentUserId = await _userService.getUserId();
      await loadUser(_currentUserId);
    } catch (e) {
      // handle any exceptions thrown from UserService
    }
  }

  Future<void> loadUser(String userId) async {
    try {
      _user = await _userService.fetchUser(userId);
      notifyListeners();
    } catch (e) {
      // handle any exceptions thrown from UserService
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await _userService.updateUser(updatedUser);
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      // handle any exceptions thrown from UserService
    }
  }

  Future<void> deleteUser() async {
    try {
      await _userService.deleteUser(_user.uid);
      _user = UserModel.empty();
      notifyListeners();
    } catch (e) {
      // handle any exceptions thrown from UserService
    }
  }
}
