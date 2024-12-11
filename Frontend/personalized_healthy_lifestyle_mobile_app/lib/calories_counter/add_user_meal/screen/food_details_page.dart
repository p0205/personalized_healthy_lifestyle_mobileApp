

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/user/blocs/user_bloc.dart';

import '../../../common_widgets/donut_chart.dart';
import '../../../user/blocs/user_state.dart';
import '../../calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../../calories_counter_main/screen/calories_counter_main.dart';
import '../../models/meal.dart';
import '../blocs/add_meal_bloc.dart';

class FoodDetailsPage extends StatelessWidget{
  final Meal meal;
  final String mealType;
  final int userId;

  const FoodDetailsPage({super.key,
    required this.meal,
    required this.mealType,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {

    List<ChartData> nutritions = [];
    if(meal.carbsPer100g != null && meal.carbsPer100g != 0 ){
      nutritions.add(ChartData(name: "Carbs", value: meal.carbsPer100g!, color: const Color.fromARGB(156, 232, 0, 0)));
    }
    if(meal.proteinPer100g != null && meal.proteinPer100g != 0 ){
      nutritions.add(ChartData(name: "Protein", value: meal.proteinPer100g!, color: const Color.fromRGBO(18, 239, 239, 0.612)));
    }
    if(meal.fatPer100g != null && meal.fatPer100g != 0 ){
      nutritions.add(ChartData(name: "Fat", value: meal.fatPer100g!, color: const Color.fromRGBO(248, 233, 60, 0.612)));
    }

    return BlocProvider(
      create: (context) => AddMealBloc(meal: meal, mealType: mealType, userId: userId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Food'),
          backgroundColor: Colors.blueAccent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Text(meal.name,
                      style: const TextStyle(
                          fontSize: 19,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Itim"
                      )
                  ),
                ),
                const SizedBox(height: 15), // Add top spacing

                 Center(
                  child: DonutChart(
                    dataList: nutritions,
                    donutSizePercentage: 0.7,
                    columnLabel: "Value per 100 g (g)",
                    containerHeight: 250,
                    centerText: meal.energyPer100g != null ? "${meal.energyPer100g?.toStringAsFixed(2)} cals\n per 100 g" : null
                  ),
                ),
                const SizedBox(height: 30),

                meal.unitWeight != null ?
                 Text(
                    "Serving size: ${meal.unitWeight}g",
                  style: const TextStyle(
                      fontSize: 15,
                    fontWeight: FontWeight.w800,

                  ),
                ) : const SizedBox(height: 21) ,

                const SizedBox(height: 10), // Add top spacing

                _toggleButton(
                    meal: meal,
                    mealType: mealType,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}

class _toggleButton extends StatefulWidget{

  final Meal meal;
  final String mealType;

  const _toggleButton({
    Key? key,
    required this.meal,
    required this.mealType
  }) : super(key: key);

  @override
  State<_toggleButton> createState() => _toggleButtonState();
}

class _toggleButtonState extends State<_toggleButton> {

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double? userInputValue ;
    return BlocConsumer<AddMealBloc,AddMealState>(
      builder: (context, state) {
        return Column(
          children: [
            ToggleButtons(
              isSelected: [
                state.isNoOfServingSelected,
                !state.isNoOfServingSelected
              ],
              onPressed: (int index){
                final model = BlocProvider.of<AddMealBloc>(context);
                if(index == 0 ){
                  model.add(NoOfServingsSelected());
                }else{
                  model.add(AmountInGramsSelected());
                }
              },
              color: Colors.grey,
              selectedColor: Colors.blue,
              fillColor: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("Number of Servings"),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("Amount in grams")
                ),
              ],
            ),
            const SizedBox(height: 10),

            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Number of servings or Amount in grams can't be empty");
                }
                try{
                  userInputValue = double.parse(value);
                  return null;
                }catch(e){
                  return ("Enter number only");
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _controller, // Attach the controller to the TextField
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      final model = BlocProvider.of<AddMealBloc>(context);
                      setState(() {
                        _controller.clear();
                        model.add(DisposeCalculation());
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  border: const OutlineInputBorder().copyWith(
                    borderRadius: const BorderRadius.all(Radius.circular(50.0),),
                  ),

                  errorMaxLines: 4,
                  hintText: state.isNoOfServingSelected == true ? "Number of servings" : "Amount in grams",
                  hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width  * 0.5,
                  )
              ),
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),

            Visibility(
              visible: !state.isCalculated,
              child: ElevatedButton(onPressed: ()
              {
                final model = BlocProvider.of<AddMealBloc>(context);
                model.add(UserInput(food: widget.meal, userInput: userInputValue!));

              },
                  child: const Text("Calculate Calories")
              ),
            ),

            Visibility(
                visible: state.isCalculated,
                child: const NutrientCardGroup()
            ),

            const SizedBox(height: 15),

            Visibility(
              visible: state.isCalculated,
              child: ElevatedButton(onPressed: () async
              {
                final model = BlocProvider.of<AddMealBloc>(context);
                final userState = BlocProvider.of<UserBloc>(context).state;
                final userMealState = model.state;

                if (userState is LoginSuccess) {
                  model.add(
                      AddMealBtnClicked(
                      mealType: widget.mealType.toUpperCase(),
                      amountInGrams: userMealState.amountIntakeInGrams!,
                      carbsInGrams: userMealState.carbsIntake,
                      proteinInGrams: userMealState.proteinIntake,
                      fatInGrams: userMealState.fatIntake,
                      calories: userMealState.energyIntake,
                    )
                  );
                }

              },
                  child: const Text("Add")
              ),
            ),
          ],
        );
      },
      listener: (context, state) {

                final caloriesCounterBloc = context.read<CaloriesCounterMainBloc>();
                caloriesCounterBloc.add(ReloadMealList());
               //
               // bool isNewDataLoaded = false;
               // // Show loading dialog
               //
               // // Listen to CaloriesCounterMainBloc state changes
               caloriesCounterBloc.stream.listen((counterState) {
               //
               //   if(counterState.status !=  CaloriesCounterMainStatus.loading){
               //     if (counterState.mealList != null || counterState.mealList!.isNotEmpty) {
               //       isNewDataLoaded = true;  // Mark that we've started loading new data
               //     }
               //   }
                 if (counterState.status == CaloriesCounterMainStatus.mealListReloaded ) {
                   showDialog(
                     context: context,
                     builder: (context) => Center(
                       child: AlertDialog(
                         content: const Text(
                             "Meal is added."),
                         actions: <Widget>[
                           // usually buttons at the bottom of the dialog
                            ElevatedButton(
                             child: const Text("OK"),
                             onPressed: () {
                               Navigator.pushReplacement(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => CaloriesCounterMain(
                                     mealList: counterState.mealList,
                                     summary: counterState.summary!,
                                   ),
                                 ),
                               );// Close the dialog
                             },
                           ),
                         ],
                       )
                     ),
                   );

                 }
               });
           },

      listenWhen: (previous,current){
        return current.status == AddMealStatus.mealAdded;
      },

    );
  }
}



class NutrientCardGroup extends StatefulWidget {

   const NutrientCardGroup({super.key});
  @override
  _NutrientCardGroupState createState() => _NutrientCardGroupState();
}

class _NutrientCardGroupState extends State<NutrientCardGroup> {
  // Nutrient values

  // NutrientCard widget to display individual nutrient info
  Widget nutrientCard(String title, String value) {

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMealBloc,AddMealState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    nutrientCard("Calories", "${state.energyIntake?.toStringAsFixed(2) ?? 0} kcal"),
                    nutrientCard("Carbs", "${state.carbsIntake?.toStringAsFixed(2) ?? 0} g"),
                    nutrientCard("Protein", "${state.proteinIntake?.toStringAsFixed(2) ?? 0} g"),
                    nutrientCard("Fat", "${state.fatIntake?.toStringAsFixed(2) ?? 0} g"),
                  ],
                ),
              ],
            ),
          ),
        );
      },

    );
  }
}
