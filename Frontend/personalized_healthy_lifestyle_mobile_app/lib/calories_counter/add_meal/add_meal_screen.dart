import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/calories_counter/add_meal/blocs/add_meal_bloc.dart';
import 'package:schedule_generator/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import 'package:schedule_generator/calories_counter/calories_counter_main/screen/calories_counter_main.dart';

class AddMealScreen extends StatefulWidget {


  const AddMealScreen({super.key});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  String _measurementType = 'per100g';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddMealBloc,AddMealState>(
            builder: (context, state) {
              return Form(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a meal name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      child: Column(
                        children: [
                          // _buildMacronutrientChart(),
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
                      final bloc = context.read<AddMealBloc>();
                      bloc.add(AddMealBtnSelectedEvent(
                          mealNameInputString: _nameController.text,
                          unitWeightInputString: _unitWeightController.text,
                          energyInputString: _energyController.text,
                          carbsInputString: _carbsController.text,
                          proteinInputString: _proteinController.text,
                          fatInputString: _fatController.text));
                    },
                      // onPressed: _submitForm,
                      child: const Text('Add New Meal'),
                    ),
                  ],
                ),
              );
            },
            listener: (BuildContext context, AddMealState state) {
              showDialog(
                context: context,
                builder: (context) => Center(
                    child: AlertDialog(
                      content: const Text(
                          "New Meal is added."),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        ElevatedButton(
                          child: const Text("OK"),
                          onPressed: () {
                            final mainBloc = context.read<CaloriesCounterMainBloc>();
                            mainBloc.add(LoadInitialDataEvent());
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CaloriesCounterMainScreen(),
                              ),
                            );// Close the dialog
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

  // Widget _buildMacronutrientChart() {
  //   return CustomPaint(
  //     size: const Size(200, 200),
  //     painter: MacronutrientChartPainter(
  //       calories: double.tryParse(_energyController.text) ?? 0,
  //       carbs: double.tryParse(_carbsController.text) ?? 0,
  //       protein: double.tryParse(_proteinController.text) ?? 0,
  //       fat: double.tryParse(_fatController.text) ?? 0,
  //     ),
  //   );
  // }

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
                  // setState(() => _measurementType = 'per100g'),
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
                  'Unit Weight',
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

  Widget _buildNutritionInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
      // onChanged: (_) => setState(() {}),
    );
  }

  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     final mealData = {
  //       'name': _nameController.text,
  //       'measurementType': _measurementType,
  //       'unitWeight': _measurementType == 'unitWeight' ? double.parse(_unitWeightController.text) : null,
  //       'energy': double.parse(_energyController.text),
  //       'carbs': double.parse(_carbsController.text),
  //       'protein': double.parse(_proteinController.text),
  //       'fat': double.parse(_fatController.text),
  //     };
  //     widget.onSubmit(mealData);
  //     _formKey.currentState!.reset();
  //   }
  // }

  @override
  void dispose() {
    _nameController.dispose();
    _unitWeightController.dispose();
    _energyController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }
}

// class MacronutrientChartPainter extends CustomPainter {
//   final double calories;
//   final double carbs;
//   final double protein;
//   final double fat;
//
//   MacronutrientChartPainter({
//     required this.calories,
//     required this.carbs,
//     required this.protein,
//     required this.fat,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;
//
//     final total = carbs + protein + fat;
//     if (total == 0) return;
//
//     final carbsAngle = 2 * pi * (carbs / total);
//     final proteinAngle = 2 * pi * (protein / total);
//     final fatAngle = 2 * pi * (fat / total);
//
//     final carbsPaint = Paint()..color = Colors.red[200]!;
//     final proteinPaint = Paint()..color = Colors.cyan[200]!;
//     final fatPaint = Paint()..color = Colors.yellow[200]!;
//
//     var startAngle = -pi / 2;
//
//     canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, carbsAngle, true, carbsPaint);
//     startAngle += carbsAngle;
//
//     canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, proteinAngle, true, proteinPaint);
//     startAngle += proteinAngle;
//
//     canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, fatAngle, true, fatPaint);
//
//     // Draw center circle
//     final centerCirclePaint = Paint()..color = Colors.white;
//     canvas.drawCircle(center, radius * 0.6, centerCirclePaint);
//
//     // Draw text
//     final textPainter = TextPainter(
//       text: TextSpan(
//         text: '${calories.toStringAsFixed(0)}\ncalories',
//         style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
//       ),
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.layout(minWidth: 0, maxWidth: size.width);
//     textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }