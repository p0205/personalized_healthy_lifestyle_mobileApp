
import 'package:schedule_generator/search_food/models/food.dart';
import 'package:schedule_generator/add_meal/repository/meal_data_provider.dart';

import '../../search_food/models/user.dart';

class MealRepository{
  final MealDataProvider mealDataProvider = MealDataProvider();

  Future<void> addMeal (User user, String mealType, double amountInGrams, Food food) async {
    await mealDataProvider.addMeal(user, mealType, amountInGrams, food);
  }
}
