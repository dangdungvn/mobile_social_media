import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/common/utils/api_constants.dart';
import 'package:mobile/features/auth/models/user_model.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Endpoint for login
  Future<String> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/token/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final token = data['auth_token'];

        // Save token
        await _secureStorage.write(key: 'authToken', value: token);

        return token;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        throw Exception(
          error['non_field_errors']?.first ??
              'Login failed. Please check your credentials.',
        );
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Endpoint for registration
  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/users/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'first_name': firstName ?? '',
          'last_name': lastName ?? '',
        }),
      );

      if (response.statusCode == 201) {
        // Registration successful
        return;
      } else {
        final Map<String, dynamic> error = json.decode(response.body);
        final List<String> errorMessages = [];

        if (error.containsKey('username')) {
          errorMessages.add('Username: ${error['username'].join(', ')}');
        }
        if (error.containsKey('email')) {
          errorMessages.add('Email: ${error['email'].join(', ')}');
        }
        if (error.containsKey('password')) {
          errorMessages.add('Password: ${error['password'].join(', ')}');
        }
        if (error.containsKey('non_field_errors')) {
          errorMessages.add(error['non_field_errors'].join(', '));
        }

        throw Exception(
          errorMessages.isNotEmpty
              ? errorMessages.join('\n')
              : 'Registration failed. Please try again.',
        );
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Get current user profile
  Future<UserModel?> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/auth/users/me/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user profile: ${e.toString()}');
      return null;
    }
  }

  // Logout
  Future<void> logout(String token) async {
    try {
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/token/logout/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      // Clear stored token
      await _secureStorage.delete(key: 'authToken');
    } catch (e) {
      print('Error during logout: ${e.toString()}');
      // Still clear token even if server call fails
      await _secureStorage.delete(key: 'authToken');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'authToken');
    return token != null && token.isNotEmpty;
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'authToken');
  }
}
