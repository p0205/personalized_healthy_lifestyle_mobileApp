
import 'package:schedule_generator/calories_counter/models/meal_summary.dart';

import '../models/user_meal.dart';
import '../search_meal/food_api_index.dart';

class MealApiRepository{

  final MealApiProvider mealApiProvider = MealApiProvider();

  Future<List<Meal>> searchMatchingFood (query) async {
    List<Meal> foods = await mealApiProvider.getMatchingMealList(query);
    return foods;
  }

  Future<Meal> selectFood(int id) async{
    Meal food = await mealApiProvider.getMeal(id);
    return food;
  }

  Future<void> addMeal(Meal meal) async {
    await mealApiProvider.addMeal(meal);
  }

  Future<Map<String, List<UserMeal>>> getUserMealListByDate(int userId, DateTime date) async {
    return await mealApiProvider.getUserMealListByDate(userId, date);
  }

  Future<void> addUserMeal (int userId, String mealType, double amountInGrams,double carbsInGrams, double proteinInGrams, double fatInGrams, double calories, int mealId) async {
    print("Enter addUserMeal Repo");
    await mealApiProvider.addUserMeal(userId, mealType,  amountInGrams, carbsInGrams,  proteinInGrams,  fatInGrams,  calories,  mealId);
    print("addUserMeal Repo End");
  }

  Future<MealSummary> getNutritionalSummary(int userId,DateTime date) async {
    return await mealApiProvider.getNutritionalSummary(userId, date);
  }

  Future<void> deleteUserMeal(int userMealId) async{
    await mealApiProvider.deleteUserMeal(userMealId);
  }
}