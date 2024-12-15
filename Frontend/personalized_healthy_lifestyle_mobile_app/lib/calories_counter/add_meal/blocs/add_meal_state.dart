part of 'add_meal_bloc.dart';

enum AddMealStatus {
  loading,
  failure,
  mealAdded
}


class AddMealState extends Equatable{

  final Meal? meal;
  final AddMealStatus status;
  final String? message;
  final bool isUnitWeightSelected;


  const AddMealState({
    this.status = AddMealStatus.loading,
    this.meal,
    this.message,
    this.isUnitWeightSelected = false,

  });


  @override
  List<Object?> get props => [status,meal,isUnitWeightSelected];

  AddMealState copyWith ({
    Meal? meal,
    AddMealStatus? status,
    String? message,
    bool? isUnitWeightSelected,

  })
  {
    return AddMealState(
        status: status ?? this.status,
        meal: meal ?? this.meal,
        message:  message ?? this.message,
        isUnitWeightSelected: isUnitWeightSelected?? this.isUnitWeightSelected,

    );
  }
}




