
part of 'calories_counter_main_bloc.dart';

enum CaloriesCounterMainStatus{
  initial,
  loading,
  mealListLoaded,
  mealListReloaded,
  addMealBtnClicked,
  mealDeleted
}


extension CaloriesCounterMainStateX on CaloriesCounterMainState{
  bool get isInitial => this == CaloriesCounterMainStatus.initial;
  bool get isLoading => this == CaloriesCounterMainStatus.loading;
  bool get isMealListLoaded => this == CaloriesCounterMainStatus.mealListLoaded;
  bool get mealListReloaded => this == CaloriesCounterMainStatus.mealListReloaded;
  bool get isAddMealBtnClicked => this == CaloriesCounterMainStatus.addMealBtnClicked;
  bool get isDeleteMeal => this == CaloriesCounterMainStatus.mealDeleted;
}

class CaloriesCounterMainState extends Equatable{
  final Map<String, List<UserMeal>?>? mealList;
  final CaloriesCounterMainStatus status;
  final MealSummary? summary;

  const CaloriesCounterMainState({
    this.mealList = const {},
    this.status = CaloriesCounterMainStatus.initial,
    this.summary,
});

  @override
  List<Object?> get props => [status,mealList,summary];

  CaloriesCounterMainState copyWith({
    Map<String, List<UserMeal>?>? mealList,
    CaloriesCounterMainStatus? status,
    String? mealType,
    MealSummary? summary
}){
    return CaloriesCounterMainState(
        status: status ?? this.status,
        mealList: mealList ?? this.mealList,
        summary: summary ?? this.summary,
    );
  }

}
