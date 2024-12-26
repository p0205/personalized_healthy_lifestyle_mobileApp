part of 'add_meal_bloc.dart';

enum AddMealStatus {
  initial,
  loading,
  failure,
  mealAdded,
  fileUploaded,
  extractNutriSelected,
  nutriExtracted,
  reviewInfoLoaded,
  noTableDetected,
}


class AddMealState extends Equatable{

  final Meal? meal;
  final AddMealStatus status;
  final String? message;
  final bool isUnitWeightSelected;
  final File? file;
  final bool isReviewEditable;


  const AddMealState({
    this.status = AddMealStatus.initial,
    this.meal,
    this.message,
    this.isUnitWeightSelected = false,
    this.file,
    this.isReviewEditable = false
  });


  @override
  List<Object?> get props => [status,meal,isUnitWeightSelected,file,isReviewEditable];

  AddMealState copyWith ({
    Meal? meal,
    AddMealStatus? status,
    String? message,
    bool? isUnitWeightSelected,
    File? file,
    bool? isReviewEditable
  })
  {
    return AddMealState(
        status: status ?? this.status,
        meal: meal ?? this.meal,
        message:  message ?? this.message,
        isUnitWeightSelected: isUnitWeightSelected?? this.isUnitWeightSelected,
        file: file ?? this.file,
        isReviewEditable: isReviewEditable ?? this.isReviewEditable,
    );
  }
}




