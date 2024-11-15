 import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/add_meal/repository/meal_repository.dart';
import 'package:schedule_generator/add_meal/repository/user_repository.dart';

import '../../search_food/models/food.dart';
import '../../search_food/models/user.dart';

part 'add_meal_event.dart';
part 'add_meal_state.dart';

class AddMealBloc extends Bloc<AddMealEvent,AddMealState>{

  final MealRepository mealRepository = MealRepository();
  final UserRepository userRepository = UserRepository();
  final Food food;
  final String mealType;
  double? amountIntakeInGrams;
  double? calories;
  double? carbsInGrams;
  double? proteinInGrams;
  double? fatInGrams;

  AddMealBloc({required this.food, required this.mealType}): super(const AddMealState()){
    on<NoOfServingsSelected>(_onNoOfServingSelected);
    on<AmountInGramsSelected>(_onAmountInGramsSelected);
    on<UserInput>(_onUserInput);
    on<CalculateBtnClicked>(_onBtnClicked);
    on<DisposeCalculation>(_onDisposeCalculation);
    on<AddMeal>(_onAddMeal);
  }


  Future<void> _onNoOfServingSelected(
      NoOfServingsSelected event,
      Emitter<AddMealState> emit
      ) async {
    emit(state.copyWith(isNoOfServingSelected: true));
  }

  Future<void> _onAmountInGramsSelected(
      AmountInGramsSelected event,
      Emitter<AddMealState> emit
      ) async {
    emit(state.copyWith(isNoOfServingSelected: false));
  }

  Future<void> _onUserInput(
      UserInput event,
    Emitter<AddMealState> emit
  )  async {

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
    emit(state.copyWith(isCalculated: true, carbsIntake: carbsInGrams, proteinIntake: proteinInGrams, fatIntake: fatInGrams, energyIntake: calories));
  }

  Future<void> _onBtnClicked(
      CalculateBtnClicked event,
      Emitter<AddMealState> emit
      ) async {
    if(amountIntakeInGrams != null) {
      emit(state.copyWith(isCalculated: true));
    }else{
      emit(state.copyWith(status: AddMealStatus.failure,message: "Please enter intake amount!"));
    }
  }

  Future<void> _onDisposeCalculation(
      DisposeCalculation event,
      Emitter<AddMealState> emit
      ) async {
    emit(state.copyWith(isCalculated: false));
  }


  Future<void> _onAddMeal(
      AddMeal event,
      Emitter<AddMealState> emit
      ) async {
      try{
        User user = await userRepository.fetchUser(1) ;
        mealRepository.addMeal(user, event.mealType,  double.parse(amountIntakeInGrams!.toStringAsFixed(2)) , double.parse(carbsInGrams!.toStringAsFixed(2)),  double.parse(proteinInGrams!.toStringAsFixed(2)),  double.parse(fatInGrams!.toStringAsFixed(2)),  double.parse(calories!.toStringAsFixed(2)), food);
        emit(state.copyWith(status: AddMealStatus.mealAdded));
      }catch(e){
        emit(state.copyWith(status: AddMealStatus.failure, message: e.toString()));
      }
  }
}