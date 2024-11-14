// mealAdded
// fail
// loading
// initial
// unsaved
part of 'add_meal_bloc.dart';

enum AddMealStatus{
  initial,
  loading,
  mealAdded,
  failure
}


extension AddMealStateX on AddMealState {
  bool get isInitial => this == AddMealStatus.initial;
  bool get isLoading => this == AddMealStatus.loading;
  bool get isMealAdded => this == AddMealStatus.mealAdded;
  bool get isFailure => this == AddMealStatus.failure;
}


class AddMealState extends Equatable {
  final AddMealStatus status;
  final double? carbsIntake;
  final double? proteinIntake;
  final double? fatIntake;
  final double? energyIntake;
  final String? message;
  final bool isNoOfServingSelected;
  final bool isCalculated;

  const AddMealState({
    this.status = AddMealStatus.initial,
    this.isNoOfServingSelected = true,
    this.isCalculated = false,
    this.carbsIntake,
    this.proteinIntake,
    this.fatIntake,
    this.energyIntake,
    this.message
  });

  @override
  List<Object?> get props => [status, carbsIntake, proteinIntake, fatIntake,energyIntake, message, isNoOfServingSelected, isCalculated];

  AddMealState copyWith({
    AddMealStatus? status,
    bool? isNoOfServingSelected,
    bool? isCalculated,
    double? carbsIntake,
    double? proteinIntake,
    double? fatIntake,
    double? energyIntake,
    String? message

  }) {
    return AddMealState(
      status: status ?? this.status,
      isNoOfServingSelected: isNoOfServingSelected?? this.isNoOfServingSelected,
      isCalculated: isCalculated ?? this.isCalculated,
      carbsIntake: carbsIntake ?? this.carbsIntake,
      proteinIntake: proteinIntake ?? this.proteinIntake,
      fatIntake: fatIntake ?? this.fatIntake,
      energyIntake: energyIntake ?? this.energyIntake,
      message: message ?? this.message,
    );
  }
}
