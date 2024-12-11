import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/calories_counter/models/meal_summary.dart';
import 'package:schedule_generator/calories_counter/models/user_meal.dart';
import 'package:schedule_generator/calories_counter/repository/meal_repository.dart';

part 'calories_counter_main_event.dart';
part 'calories_counter_main_state.dart';

class CaloriesCounterMainBloc extends Bloc<CaloriesCounterMainEvent,CaloriesCounterMainState>{
  final MealApiRepository mealRepository = MealApiRepository();
  int userId;
  DateTime date;

  CaloriesCounterMainBloc({required this.userId, required this.date}): super(const CaloriesCounterMainState(status: CaloriesCounterMainStatus.loading)){
    on<AddBtnClicked>(_addMealBtnClicked);
    on<LoadInitialDataEvent>(_init);
    on<ReloadMealList>(_reload);
    on<DeleteMealBtnClicked>(_delete);
  }

  Future<void> _addMealBtnClicked(
      AddBtnClicked event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(status: CaloriesCounterMainStatus.addMealBtnClicked, mealType: event.mealType));
  }

  Future<void> _init(
      LoadInitialDataEvent event,
      Emitter<CaloriesCounterMainState> emit
  )async{
    print("Enter initializing");
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    print("final mealList = await mealRepository.getUserMealListByDate(userId, date);");
    final mealList = await mealRepository.getUserMealListByDate(userId, date);
    print("final nutritionalSummary = await mealRepository.getNutritionalSummary(userId,date);");
    final nutritionalSummary = await mealRepository.getNutritionalSummary(userId,date);
    print("emit(state.copyWith(status: CaloriesCounterMainStatus.mealListLoaded, mealList: mealList, summary: nutritionalSummary));");
    emit(state.copyWith(status: CaloriesCounterMainStatus.mealListLoaded, mealList: mealList, summary: nutritionalSummary));
    print(mealList.toString());
  }

  Future<void> _reload(
      ReloadMealList event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    final mealList = await mealRepository.getUserMealListByDate(userId, date);
    final nutritionalSummary = await mealRepository.getNutritionalSummary(userId,date);
    emit(state.copyWith(status: CaloriesCounterMainStatus.mealListReloaded, mealList: mealList, summary: nutritionalSummary));
  }

  Future<void> _delete(
      DeleteMealBtnClicked event,
      Emitter<CaloriesCounterMainState> emit
      )async{
    emit(state.copyWith(status: CaloriesCounterMainStatus.loading, mealList: {}));
    await mealRepository.deleteUserMeal(event.userMealId);
    _init;
    print("after init");
    print(state.mealList.toString());
    emit(state.copyWith(status: CaloriesCounterMainStatus.mealDeleted));
  }
}


