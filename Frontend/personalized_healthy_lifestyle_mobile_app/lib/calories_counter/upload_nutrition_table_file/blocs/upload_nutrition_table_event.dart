part of 'upload_nutrition_table_bloc.dart';

class UploadNutritionTableEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class UploadFileEvent extends UploadNutritionTableEvent{}

class ExtractNutriEvent extends UploadNutritionTableEvent{
  final File file;
  ExtractNutriEvent({required this.file});
}
