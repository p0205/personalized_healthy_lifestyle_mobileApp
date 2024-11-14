
import '../food_api_index.dart';

class FoodApiRepository{

  final FoodApiProvider foodApiProvider = FoodApiProvider();

  Future<List<Food>> searchMatchingFood (query) async {
    print("api repo fetching....");
    List<Food> foods = await foodApiProvider.searchMatchingFood(query);
    print("api repo end....");
    return foods;
  }

  Future<Food> selectFood(int id) async{
    Food food = await foodApiProvider.selectFood(id);
    return food;
  }

}