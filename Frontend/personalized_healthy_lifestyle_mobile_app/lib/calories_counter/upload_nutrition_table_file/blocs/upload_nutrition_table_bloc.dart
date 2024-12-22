// import 'dart:io';
//
// import 'package:equatable/equatable.dart';
// import 'package:file_picker/file_picker.dart';
// // import 'package:file_picker/file_picker.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:schedule_generator/calories_counter/repository/meal_repository.dart';
//
// import '../../models/meal.dart';
//
// part 'upload_nutrition_table_event.dart';
// part 'upload_nutrition_table_state.dart';
//
// class UploadNutritionTableBloc extends Bloc<UploadNutritionTableEvent,UploadNutritionTableState>{
//
//   final MealApiRepository mealApiRepository = MealApiRepository();
//
//   UploadNutritionTableBloc()
//       : super(const UploadNutritionTableState())  {
//     on<UploadFileEvent>(_uploadFile);
//     on<ExtractNutriEvent>(_extractNutri);
//   }
//
//
//   Future<void> _extractNutri (
//       ExtractNutriEvent event,
//       Emitter<UploadNutritionTableState> emit
//       )async{
//     emit(state.copyWith(status: UploadNutritionTableStatus.loading));
//     try{
//       Meal? meal = await mealApiRepository.extractNutrition(event.file);
//       emit(state.copyWith(status: UploadNutritionTableStatus.nutriExtracted, meal: meal));
//     }catch(e){
//       emit(state.copyWith(status: UploadNutritionTableStatus.failure,message: e.toString()));
//     }
//   }
//
//   Future<void> _uploadFile (
//       UploadFileEvent event,
//       Emitter<UploadNutritionTableState> emit
//       )async{
//     try{
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         // allowedExtensions: ['jpg', 'jpeg', 'png'],
//       );
//       if (result != null) {
//         final file = File(result.files.single.path!);
//         emit(state.copyWith(status: UploadNutritionTableStatus.fileUploaded, file: file));
//       } else {
//         emit(state.copyWith(status: UploadNutritionTableStatus.failure,message:"No file selected"));
//       }
//     }catch(e){
//       emit(state.copyWith(status: UploadNutritionTableStatus.failure,message: e.toString()));
//     }
//   }
//
//
//
//
// }