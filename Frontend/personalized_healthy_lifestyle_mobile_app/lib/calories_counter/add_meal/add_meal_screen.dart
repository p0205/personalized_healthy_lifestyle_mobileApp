import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/calories_counter/add_meal/blocs/add_meal_bloc.dart';

import '../upload_nutrition_table_file/blocs/upload_nutrition_table_bloc.dart';
import '../upload_nutrition_table_file/upload_nutrition_table_file_screen.dart';

class AddMealScreen extends StatefulWidget {

  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _unitWeightController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddMealBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),

        title: const Text('Add New Meal', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddMealBloc,AddMealState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildUploadNutritionTable(),
                  TextButton(
                    onPressed: _showImageUploadInfo,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 16),
                        SizedBox(width: 2),
                        Text('How it works', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCard(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Meal Name',
                              border: OutlineInputBorder(),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a meal name';
                              }else if(value.length <= 3){
                                return 'Meal name must longer than 3 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCard(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildMeasurementTypeToggle(),
                              if (bloc.state.isUnitWeightSelected) ...[
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _unitWeightController,
                                  decoration: const InputDecoration(
                                    labelText: 'Unit Weight (g)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (bloc.state.isUnitWeightSelected &&
                                        (value == null || value.isEmpty)) {
                                      return 'Please enter the unit weight';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              const SizedBox(height: 16),
                              _buildNutritionInput(
                                  'Energy (kcal)', _energyController),
                              const SizedBox(height: 16),
                              _buildNutritionInput(
                                  'Carbohydrates (g)', _carbsController),
                              const SizedBox(height: 16),
                              _buildNutritionInput(
                                  'Protein (g)', _proteinController),
                              const SizedBox(height: 16),
                              _buildNutritionInput('Fat (g)', _fatController),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          // onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ), onPressed: () {
                          if (_formKey.currentState!.validate() && _nameController.text.isNotEmpty) {
                            final bloc = context.read<AddMealBloc>();
                            bloc.add(AddMealBtnSelectedEvent(
                                mealNameInputString: _nameController.text,
                                unitWeightInputString: _unitWeightController.text,
                                energyInputString: _energyController.text,
                                carbsInputString: _carbsController.text,
                                proteinInputString: _proteinController.text,
                                fatInputString: _fatController.text));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all required fields')),
                            );
                          }
                        },
                          // onPressed: _submitForm,
                          child: const Text('Add New Meal'),
                        ),
                      ],
                    ),
                  ),
              ],
              );
            },

            listener: (BuildContext context, AddMealState state) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                    child: AlertDialog(
                      content: const Text(
                          "New Meal is added."),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        ElevatedButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.settings.name == "/mealMain");
                          },
                        ),
                      ],
                    )
                ),
              );
            },
            listenWhen: (previous,current){
              return (current.status == AddMealStatus.mealAdded);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildMeasurementTypeToggle() {
    final bloc = context.read<AddMealBloc>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                bloc.add(Per100SelectedEvent());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !bloc.state.isUnitWeightSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Per 100g',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !bloc.state.isUnitWeightSelected ? Colors.blue : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: ()  {
                bloc.add(UnitWeightSelectedEvent());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: bloc.state.isUnitWeightSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Per Unit Weight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: bloc.state.isUnitWeightSelected ? Colors.blue : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadNutritionTable(){
    return DottedBorder(
      borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        dashPattern: const [10,10],
        color: Colors.grey,
        strokeWidth: 2,
        child: InkWell(
          onTap: (){
            context.read<UploadNutritionTableBloc>().add(UploadFileEvent());
          },
          child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20), // Circular edges
                  ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt, color: Colors.blue, size: 32),
                 SizedBox(height: 8),
                 Text(
                  'Upload Nutrition Table',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                 SizedBox(height: 4),
                 Text(
                  'Quick fill meal details',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
              ),),
        )
    );
  }

  Widget _buildNutritionInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
    );
  }

  void _showImageUploadInfo() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How to Use Image Upload', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                    '1. Tap the "Upload Nutrition Table" button.\n'
                    '2. Upload a clear photo of the nutrition table.\n'
                    '3. Our system will automatically extract and fill in the nutritional information for you.\n'
                    '4. Review and adjust the information if needed.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

}
