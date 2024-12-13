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

class AddMealState extends Equatable {
  final AddMealStatus status;
  final double? amountIntakeInGrams;
  final double? carbsIntake;
  final double? proteinIntake;
  final double? fatIntake;
  final double? energyIntake;
  final String? message;
  final bool isNoOfServingSelected;
  final bool isCalculated;
  final int userId;
  final int mealId;

  const AddMealState({
    required this.userId,
    required this.mealId,
    this.status = AddMealStatus.initial,
    this.isNoOfServingSelected = true,
    this.isCalculated = false,
    this.amountIntakeInGrams,
    this.carbsIntake,
    this.proteinIntake,
    this.fatIntake,
    this.energyIntake,
    this.message
  });

  @override
  List<Object?> get props => [userId, mealId, status, amountIntakeInGrams, carbsIntake, proteinIntake, fatIntake,energyIntake, message, isNoOfServingSelected, isCalculated];

  AddMealState copyWith({
    int? userId,
    int? mealId,
    AddMealStatus? status,
    bool? isNoOfServingSelected,
    bool? isCalculated,
    double? amountIntakeInGrams,
    double? carbsIntake,
    double? proteinIntake,
    double? fatIntake,
    double? energyIntake,
    String? message

  }) {
    return AddMealState(
      userId: userId ?? this.userId,
      mealId: mealId ?? this.userId,
      status: status ?? this.status,
      isNoOfServingSelected: isNoOfServingSelected?? this.isNoOfServingSelected,
      isCalculated: isCalculated ?? this.isCalculated,
      amountIntakeInGrams: amountIntakeInGrams ?? this.amountIntakeInGrams,
      carbsIntake: carbsIntake ?? this.carbsIntake,
      proteinIntake: proteinIntake ?? this.proteinIntake,
      fatIntake: fatIntake ?? this.fatIntake,
      energyIntake: energyIntake ?? this.energyIntake,
      message: message ?? this.message,
    );
  }
}
