// part of 'upload_nutrition_table_bloc.dart';
//
//
// enum UploadNutritionTableStatus{
//   initial,
//   loading,
//   fileUploaded,
//   failure,
//   extractNutriSelected,
//   nutriExtracted,
//   noTableDetected
// }
//
// class UploadNutritionTableState extends Equatable{
//   final UploadNutritionTableStatus status;
//   final Meal? meal;
//   final String? message;
//   final File? file;
//
//   const UploadNutritionTableState({
//     this.status = UploadNutritionTableStatus.initial,
//     this.meal,
//     this.message,
//     this.file
//   });
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [status,meal];
//
//   UploadNutritionTableState copyWith ({
//     UploadNutritionTableStatus? status,
//     String? message,
//     Meal? meal,
//     File? file
//   })
//   {
//     return UploadNutritionTableState(
//         status: status ?? this.status,
//         message:  message ?? this.message,
//         meal: meal ?? this.meal,
//         file: file ?? this.file
//     );
//   }
// }
//
