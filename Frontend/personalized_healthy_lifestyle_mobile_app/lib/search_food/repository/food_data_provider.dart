//search food return List<Food> (id ,name)
//search specific food return Food
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schedule_generator/search_food/food_api_index.dart';

//Exception throw when foodSearch fails
class FoodRequestFailure implements Exception{}


class FoodApiProvider{

  static const _baseUrl = "localhost:8080";
  final http.Client _httpClient;

  FoodApiProvider({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  // api : localhost:8080/food/search
  Future<List<Food>> searchMatchingFood(String query) async {
  print("api provider fetching...");

    final uri = Uri.http(_baseUrl,"/food/search",{'name':query});
    // Debug print
  print(uri);
    final response = await _httpClient.get(uri);
    // Debug print
  print(response.body.toString());

    if(response.statusCode != 200){
      throw FoodRequestFailure();
    }
    List<Food> foods =  Food.fromJsonArray(json.decode(response.body));
    return foods;
  }

  Future<Food> selectFood(int id) async {
    print("api provider fetching select food...");

    final uri = Uri.http(_baseUrl,"/food/${id.toString()}");
    // Debug print
    print(uri);
    final response = await _httpClient.get(uri);
    // Debug print
    print(response.body.toString());

    if(response.statusCode != 200){
      throw FoodRequestFailure();
    }
    Food  food =  Food.fromJson(json.decode(response.body));
    return food;
  }



}
