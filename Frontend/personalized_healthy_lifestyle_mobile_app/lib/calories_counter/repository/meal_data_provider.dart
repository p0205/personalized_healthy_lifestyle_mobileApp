//search food return List<Food> (id ,name)
//search specific food return Food
import 'dart:convert';
import 'dart:core';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_generator/calories_counter/models/meal_summary.dart';
import 'package:schedule_generator/calories_counter/models/user_meal.dart';

import '../models/meal.dart';

//Exception throw when foodSearch fails
class getMatchingFoodListFailure implements Exception{}
class getFoodFailure implements Exception{}
class AddMealFailure implements Exception{}
class AddUserMealFailure implements Exception{}
class DeleteUserMealFailure implements Exception{}

class MealApiProvider{

  final String _baseUrl;
  final http.Client _httpClient;

  MealApiProvider({http.Client? httpClient})
      : _baseUrl = _getBaseUrl(),
        _httpClient = httpClient ?? http.Client();

  static String _getBaseUrl() {
    if (Platform.isAndroid) {
      return "10.0.2.2:8080"; // Android emulator localhost
    } else {
      return "localhost:8080";
    }
  }

  // api : localhost:8080/meal/search
  Future<List<Meal>> getMatchingMealList(String query) async {
    final uri = Uri.http(_baseUrl,"/meal/search",{'name':query});
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw getMatchingFoodListFailure();
    }
    List<Meal> foods =  Meal.fromJsonArray(json.decode(response.body));
    return foods;
  }

  // api : GET localhost:8080/meal/{mealId}
  Future<Meal> getMeal(int id) async {

    final uri = Uri.http(_baseUrl,"/meal/${id.toString()}");

    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw getFoodFailure();
    }
    Meal food =  Meal.fromJson(json.decode(response.body));
    return food;
  }

  // api : POST localhost:8080/meal
  Future<void> addMeal(Meal meal)async{
    final uri = Uri.http(_baseUrl,"/meal");

    final response = await _httpClient.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(meal));

    if(response.statusCode != 201){
      throw AddMealFailure();
    }
  }

  // api : GET localhost:8080/meal/user?userId=?,date=?
  Future<Map<String, List<UserMeal>>> getUserMealListByDate(int userId, DateTime date) async {

    String formatedDate = formatDate(date);

    final uri = Uri.http(_baseUrl,"/meal/user",{"userId": userId.toString(), "date": formatedDate});
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw AddMealFailure();
    }

    final Map<String, dynamic> data = json.decode(response.body);

    print(data.toString());
    return data.map((key, value) {
      final meals = (value as List).map((meal) => UserMeal.fromJson(meal)).toList();
      return MapEntry(key, meals);
    });
  }

  Future<void> addUserMeal(int userId, String mealType, double amountInGrams,double carbsInGrams, double proteinInGrams, double fatInGrams, double calories, int mealId) async {
    Map<String,Object> request = {
      "mealType": mealType,
      "userId": userId,
      "mealId": mealId,
      "amountInGrams": amountInGrams,
      "calories": calories,
      "carbsInGrams": carbsInGrams,
      "proteinInGrams":proteinInGrams,
      "fatInGrams": fatInGrams,
    };
    // final uri = Uri.http(_baseUrl,"/meal/user",{"userId": userId.toString()});
    final uri = Uri.http(_baseUrl,"/meal/user");
    final response = await _httpClient.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request)
    );

    if(response.statusCode != 201){
      print(response.statusCode);
      throw AddUserMealFailure();
    }
  }

  Future<MealSummary> getNutritionalSummary(int userId,DateTime date) async{
    String formatedDate = formatDate(date);

    final uri = Uri.http(_baseUrl,"/meal/user/summary",{"userId": userId.toString(), "date": formatedDate});
    final response = await _httpClient.get(uri);

    if(response.statusCode != 200){
      throw AddMealFailure();
    }
    final Map<String, dynamic> data = json.decode(response.body);
    return MealSummary.fromJson(data);
  }

  // api : GET localhost:8080/meal/user/{mealId}
  Future<UserMeal?> getUserMeal(int userId, int mealId) async { return null;}

  // api : DELETE localhost:8080/meal/user/{userMealId}
  Future<void> deleteUserMeal(int userMealId) async {
    final uri = Uri.http(_baseUrl,"/meal/user/delete/${userMealId.toString()}");
    final response = await _httpClient.delete(uri);
    if(response.statusCode != 204){
      throw DeleteUserMealFailure();
    }
  }


}

String formatDate(DateTime dateTime){
  return dateTime.toString().split(' ')[0];
}
