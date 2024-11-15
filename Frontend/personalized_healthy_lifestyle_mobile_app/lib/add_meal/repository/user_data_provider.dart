import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../search_food/models/user.dart';

class UserDataProvider {

  final String _baseUrl;
  final http.Client _httpClient;

  UserDataProvider({http.Client? httpClient})
      : _baseUrl = _getBaseUrl(),
        _httpClient = httpClient ?? http.Client();

  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8080/user"; // Android emulator localhost
    } else{
      return "http://localhost:8080/user"; // Default for other platforms
    }
  }


  Future<User> fetchUser(int id) async {
    try {
      print("Enter user data provider...");
      // Use string interpolation correctly
      final uri = Uri.parse("$_baseUrl/$id");
      print("Requesting URL: $uri");

      final response = await _httpClient.get(uri);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching user: $e");
      rethrow;
    }
  }
}