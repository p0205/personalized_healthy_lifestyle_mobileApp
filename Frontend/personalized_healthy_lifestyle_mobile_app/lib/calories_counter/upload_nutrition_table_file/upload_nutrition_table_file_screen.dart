
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/calories_counter/upload_nutrition_table_file/blocs/upload_nutrition_table_bloc.dart';

class UploadNutritionTableFileScreen extends StatelessWidget {
  const UploadNutritionTableFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Nutrition Table'),
      ),
      body: BlocBuilder<UploadNutritionTableBloc, UploadNutritionTableState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  if(state.status == UploadNutritionTableStatus.initial)
                  ElevatedButton(
                    onPressed: () => context.read<UploadNutritionTableBloc>().add(UploadFileEvent()),
                    child: const Text("Upload File"),
                  ),
                  if (state.status == UploadNutritionTableStatus.loading)
                    const Center(child: CircularProgressIndicator()),
                  if (state.status == UploadNutritionTableStatus.fileUploaded && state.file!=null)
                    ElevatedButton(
                      onPressed: () => context.read<UploadNutritionTableBloc>().add(ExtractNutriEvent(file: state.file!)),
                      child: const Text("Extract Nutrition"),
                    ),
                  if(state.status == UploadNutritionTableStatus.nutriExtracted)

                  if (state.status == UploadNutritionTableStatus.failure)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {

  }
}

