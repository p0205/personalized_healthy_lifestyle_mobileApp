part of 'add_meal_bloc.dart';

abstract class AddMealEvent extends Equatable{
  const AddMealEvent();
  @override
  List<Object?> get props => [];
}

class AddMealBtnSelectedEvent extends AddMealEvent {
  final String mealNameInputString;
  final String? unitWeightInputString;
  final String? energyInputString;
  final String? carbsInputString;
  final String? proteinInputString;
  final String? fatInputString;

  const AddMealBtnSelectedEvent(
      {
        required this.mealNameInputString,
        required this.unitWeightInputString,
        required this.energyInputString,
        required this.carbsInputString,
        required this.proteinInputString,
        required this.fatInputString,
      }
  );
}

class Per100SelectedEvent extends AddMealEvent {}

class UnitWeightSelectedEvent extends AddMealEvent {}



