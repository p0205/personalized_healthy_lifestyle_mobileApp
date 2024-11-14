import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../search_food/models/user.dart';

class UserDataProvider {
  // Add http:// to the base URL
  static const _baseUrl = "http://localhost:8080/user";
  final http.Client _httpClient;

  UserDataProvider({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

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