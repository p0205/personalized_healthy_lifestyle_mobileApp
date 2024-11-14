
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';


// import '../search_food/searchFoodPage.dart';
import '../search_food/screen/search_food_screen.dart';
import '../common_widgets/donut_chart.dart';





class CircularPercentagePage extends StatefulWidget {
  const CircularPercentagePage({super.key});

  @override
  State<CircularPercentagePage> createState() => _CircularPercentagePageState();
}

class _CircularPercentagePageState extends State<CircularPercentagePage> {

  Map<String, List<Map<String, String>>> foodSections = {
    "Breakfast": [
      {"name": "Food 1", "amount": "250 g", "calories": "150 cals"},
      {"name": "Food 2", "amount": "250 g", "calories": "100 cals"},
    ],
    "Lunch": [
      {"name": "Food 1", "amount": "250 g", "calories": "150 cals"},
      {"name": "Food 2", "amount": "250 g", "calories": "100 cals"},
    ],
    "Dinner": [
      {"name": "Food 1", "amount": "250 g", "calories": "150 cals"},
      {"name": "Food 2", "amount": "250 g", "calories": "100 cals"},
    ],
  };

  // Function to add a new food item to a specific section
  void _addFoodItem(String section) {
    setState(() {
      foodSections[section]?.add({"name": "New Food", "amount": "250 g", "calories": "100 cals"});
    });
  }

  @override
  Widget build(BuildContext context) {
    int calories = 800;


    return Scaffold(
      appBar: AppBar(
        title: const Text("Calories Counter"),
          backgroundColor: Colors.blueAccent,
          titleTextStyle: const TextStyle(
              fontFamily: 'Itim',
              fontSize: 25,
              fontWeight: FontWeight.bold
          ),
      ),


      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CaloriesChart(calories: 500),
                const SizedBox(height: 10),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                        itemCount: foodSections.length,
                        itemBuilder: (context,index){
                          String section = foodSections.keys.elementAt(index);
                          List<Map<String, String>> foods = foodSections[section]!;
                          return FoodIntakeCard(
                              section: section,
                              foods: foods,
                          );

                }),
              ],
            ),
        
        
        
        ),
      ),
    );
  }
}

class CaloriesChart extends StatelessWidget {
   CaloriesChart({
    super.key,
    required this.calories,
  });

  final double calories;
   bool isExceed = false;

  @override
  Widget build(BuildContext context) {

    List<ChartData> nutritions = [];

    nutritions.add(ChartData(name: "Carbs", value: 100, color: const Color.fromARGB(156, 232, 0, 0)));

    nutritions.add(ChartData(name: "Protein", value: 200, color: const Color.fromRGBO(18, 239, 239, 0.612)));

    nutritions.add(ChartData(name: "Fat", value:300, color: const Color.fromRGBO(248, 233, 60, 0.612)));

    return Center(
      child: DonutChart(
              dataList: nutritions,
              donutSizePercentage: 0.7,
              columnLabel: "Intake amount (g)",
              containerHeight: 240,
              centerText:  isExceed? "${calories.toString()} cals\nexceed": "${calories.toString()} cals\nremaining",
              centerTextColor: isExceed? Colors.redAccent : null,
        ),
    );
  }
}

class IntakePercentage extends StatelessWidget{
  const IntakePercentage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          children: [
            LinearPercentIndicator(
              leading: const Text("Carbs"),
              trailing: const Text("100/135g"),
              width: 120.0,
              animation: true,
              lineHeight: 14.0,
              percent: 0.5,
              backgroundColor: Colors.grey,
              progressColor: Colors.blue,
            ),
          ],
        ),
    );
  }
}


class FoodIntakeCard extends StatefulWidget {

  final String section;
  final List<Map<String, String>> foods;

  const FoodIntakeCard({
    Key? key,
    required this.section,
    required this.foods,
  }) : super(key: key);

  @override
  State<FoodIntakeCard> createState() => _FoodIntakeCardState();
}

class _FoodIntakeCardState extends State<FoodIntakeCard> {

  // Function to add a new food item to a specific section
  void _addFoodItem() {
    setState(() {
      Map<String,String> newFood =  {"name": "new Food", "amount": "250 g", "calories": "100 cals"};
      widget.foods.add(newFood);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(widget.section),
                const Text("250cals"),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                      final String mealType = widget.section;
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage(mealType: mealType)),
                    );
                  },
                  child: const Icon(Icons.add), // )
                ),

              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: widget.foods.map((food) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(food["name"]!),
                  subtitle: Text(food["amount"]!),
                  trailing: Text(food["calories"]!),
                );
              }).toList(),
            )
          ],
        ),

      ),
    );
  }
}
