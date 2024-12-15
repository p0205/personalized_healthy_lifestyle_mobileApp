 import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/calories_counter/repository/meal_repository.dart';

import '../../models/meal.dart';

part 'add_meal_event.dart';
part 'add_meal_state.dart';

class AddUserMealBloc extends Bloc<AddUserMealEvent,AddUserMealState>{

  final MealApiRepository mealRepository = MealApiRepository();
  final Meal meal;
  final int userId;
  final String mealType;


  AddUserMealBloc({required this.meal, required this.mealType, required this.userId})
      : super(AddUserMealState(
    userId: userId,
    mealId: meal.id!, // Map meal's id to mealId in the state
    )) {
    on<NoOfServingsSelected>(_onNoOfServingSelected);
    on<AmountInGramsSelected>(_onAmountInGramsSelected);
    on<UserInput>(_onUserInput);
    on<CalculateBtnClicked>(_onBtnClicked);
    on<DisposeCalculation>(_onDisposeCalculation);
    on<AddMealBtnClicked>(_onAddMeal);
  }


  Future<void> _onNoOfServingSelected(
      NoOfServingsSelected event,
      Emitter<AddUserMealState> emit
      ) async {
    emit(state.copyWith(isNoOfServingSelected: true));
  }

  Future<void> _onAmountInGramsSelected(
      AmountInGramsSelected event,
      Emitter<AddUserMealState> emit
      ) async {
    emit(state.copyWith(isNoOfServingSelected: false));
  }

  Future<void> _onUserInput(
      UserInput event,
    Emitter<AddUserMealState> emit
  )  async {

    double? amountIntakeInGrams;
    double? calories;
    double? carbsInGrams;
    double? proteinInGrams;
    double? fatInGrams;

    if(state.isNoOfServingSelected) {

      if(event.food.unitWeight != null){

        amountIntakeInGrams = event.userInput * event.food.unitWeight!;

        calories = (event.food.energyPer100g != null && event.food.unitWeight != null)
            ? (event.food.energyPer100g!/100) * event.food.unitWeight! * event.userInput : null;

        carbsInGrams = (event.food.carbsPer100g != null && event.food.unitWeight != null)
            ? (event.food.carbsPer100g!/100) * event.food.unitWeight! * event.userInput : null;

        proteinInGrams = (event.food.proteinPer100g != null && event.food.unitWeight != null)
            ? (event.food.proteinPer100g!/100) * event.food.unitWeight! * event.userInput : null;

        fatInGrams = (event.food.fatPer100g != null)
            ? (event.food.fatPer100g!/100) * event.food.unitWeight! * event.userInput : null;
      }else{
        calories = carbsInGrams = proteinInGrams = fatInGrams = null;
      }
    }else{
      amountIntakeInGrams = event.userInput ;
      calories = (event.food.energyPer100g != null)
          ? (event.food.energyPer100g!/100) * event.userInput : null;

      carbsInGrams = (event.food.carbsPer100g != null)
          ? (event.food.carbsPer100g!/100) * event.userInput : null;

      proteinInGrams = (event.food.proteinPer100g != null)
          ? (event.food.proteinPer100g!/100) * event.userInput : null;

      fatInGrams = (event.food.fatPer100g != null)
          ? (event.food.fatPer100g!/100) * event.userInput: null;
    }
    emit(state.copyWith(userId: userId, mealId: meal.id, isCalculated: true, amountIntakeInGrams: amountIntakeInGrams, carbsIntake: carbsInGrams, proteinIntake: proteinInGrams, fatIntake: fatInGrams, energyIntake: calories));
  }

  Future<void> _onBtnClicked(
      CalculateBtnClicked event,
      Emitter<AddUserMealState> emit
      ) async {
    if(state.amountIntakeInGrams != null) {
      emit(state.copyWith(isCalculated: true));
    }else{
      emit(state.copyWith(status: AddUserMealStatus.failure,message: "Please enter intake amount!"));
    }
  }

  Future<void> _onDisposeCalculation(
      DisposeCalculation event,
      Emitter<AddUserMealState> emit
      ) async {
    emit(state.copyWith(isCalculated: false));
  }


  Future<void> _onAddMeal(
      AddMealBtnClicked event,
      Emitter<AddUserMealState> emit
      ) async {
      try{
        await mealRepository.addUserMeal(state.userId, event.mealType, double.parse(state.amountIntakeInGrams!.toStringAsFixed(2)) , double.parse(state.carbsIntake!.toStringAsFixed(2)),  double.parse(state.proteinIntake!.toStringAsFixed(2)),  double.parse(state.fatIntake!.toStringAsFixed(2)),  double.parse(state.energyIntake!.toStringAsFixed(2)), state.mealId);
        emit(state.copyWith(status: AddUserMealStatus.mealAdded));
      }catch(e){
        emit(state.copyWith(status: AddUserMealStatus.failure, message: e.toString()));
      }
  }
}