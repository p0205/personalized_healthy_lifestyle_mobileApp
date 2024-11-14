import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../search_food/models/user.dart';
import '../../search_food/models/food.dart';

class MealDataProvider{
  static const _baseUrl = "http://localhost:8080/meals";
  final http.Client _httpClient;

  MealDataProvider({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();


  Future<void> addMeal(User user, String mealType, double amountInGrams, Food food) async {
    Map<String,Object> request = {
      "mealType": mealType,
      "user": user,
      "amountInGrams": amountInGrams,
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