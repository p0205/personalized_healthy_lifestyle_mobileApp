part of 'add_meal_bloc.dart';




abstract class AddMealEvent extends Equatable{
  const AddMealEvent();

  List<Object?> get props => [];
}

class NoOfServingsSelected extends AddMealEvent{}
class AmountInGramsSelected extends AddMealEvent{}

class UserInput extends AddMealEvent{

  final double userInput;
  final Meal food;

  const UserInput({required this.food , required this.userInput});
  List<Object?> get props => [food, userInput];
}

class DisposeCalculation extends AddMealEvent{}

class CalculateBtnClicked extends AddMealEvent{

}

class AddMealBtnClicked extends AddMealEvent{

  final String mealType;
  final double amountInGrams;
  final double? carbsInGrams;
  final double? proteinInGrams;
  final double? fatInGrams;
  final double? calories;


  const AddMealBtnClicked(
      {
        required this.mealType,
        required this.amountInGrams,
        required this.carbsInGrams,
        required this.proteinInGrams,
        required this.fatInGrams,
        required this.calories,

      }
      );
  List<Object?> get props => [ mealType, amountInGrams, carbsInGrams, proteinInGrams, fatInGrams, calories];
}
