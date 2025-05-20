import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _loadAuthStatus();
  }

  // Tải trạng thái xác thực khi khởi động ứng dụng
  Future<void> _loadAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    notifyListeners();
  }

  // Đăng nhập người dùng
  Future<void> login() async {
    // Trong thực tế, đây là nơi bạn sẽ gọi API đăng nhập
    // và lưu trữ token, thông tin người dùng, v.v.
    _isAuthenticated = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    notifyListeners();
  }

  // Đăng xuất người dùng
  Future<void> logout() async {
    _isAuthenticated = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    notifyListeners();
  }
}
