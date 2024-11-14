part of 'add_meal_bloc.dart';




abstract class AddMealEvent extends Equatable{
  const AddMealEvent();

  List<Object?> get props => [];
}

class NoOfServingsSelected extends AddMealEvent{}
class AmountInGramsSelected extends AddMealEvent{}

class UserInput extends AddMealEvent{

  final double userInput;
  final Food food;

  const UserInput({required this.food , required this.userInput});
  List<Object?> get props => [food, userInput];
}

class DisposeCalculation extends AddMealEvent{}

class CalculateBtnClicked extends AddMealEvent{

}

class AddMeal extends AddMealEvent{
  final Food food;
  final String mealType;

  const AddMeal({required this.food, required this.mealType});
  List<Object?> get props => [food, mealType];
}
