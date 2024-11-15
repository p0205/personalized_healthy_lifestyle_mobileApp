import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../search_food/models/user.dart';
import '../../search_food/models/food.dart';

class MealDataProvider{

  final String _baseUrl;
  final http.Client _httpClient;

  MealDataProvider({http.Client? httpClient})
      : _baseUrl = _getBaseUrl(),
        _httpClient = httpClient ?? http.Client();

  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8080/meals"; // Android emulator localhost
    } else {
      return "http://localhost:8080/meals";
    }
  }

  Future<void> addMeal(User user, String mealType, double amountInGrams,double carbsInGrams, double proteinInGrams, double fatInGrams, double calories, Food food) async {
    Map<String,Object> request = {
      "mealType": mealType,
      "user": user,
      "amountInGrams": amountInGrams,
      "carbsInGrams": carbsInGrams,
      "proteinInGrams":proteinInGrams,
      "fatInGrams": fatInGrams,
      "calories": calories,
      "food": food
    };

    print("Start post...");
    http.post(
        Uri.parse(_baseUrl),
        headers: <String,String> {
          "Content-Type" : "application/json;charset=UTF-8"
        },
        body: jsonEncode(request)
    );
    print("ENd post...");
  }
}