import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/calories_counter/add_meal/blocs/add_meal_bloc.dart';


class AddMealScreen extends StatefulWidget {

  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  // get the meal info from bloc
   bool isEditable = false;
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

        title: const Text('Review Meal Info', style: TextStyle(color: Colors.white)),
          actions:
          [
          IconButton(
            icon: Icon(isEditable ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: () {isEditable = !isEditable;}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddMealBloc,AddMealState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(width: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCard(
                          child: TextFormField(
                            controller: _nameController,
                            enabled: isEditable,
                            initialValue: state.meal?.name,
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
                                  initialValue: state.meal?.unitWeight.toString(),
                                  enabled: isEditable,
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
                              TextFormField(
                                controller: _energyController,
                                enabled: isEditable,
                                initialValue: context.read<AddMealBloc>().state.meal?.energyPer100g.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Energy (kcal)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                              ),

                              TextFormField(
                                controller: _carbsController,
                                enabled: isEditable,
                                initialValue: context.read<AddMealBloc>().state.meal?.carbsPer100g.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Carbohydrates (g)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                              ),

                              TextFormField(
                                controller: _proteinController,
                                enabled: isEditable,
                                initialValue: context.read<AddMealBloc>().state.meal?.proteinPer100g.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Protein (g)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                              ),

                              TextFormField(
                                controller: _fatController,
                                enabled: isEditable,
                                initialValue: context.read<AddMealBloc>().state.meal?.fatPer100g.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Fat (g)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                              ),

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
                          child: const Text('Confirm and Add Meal'),
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


}
