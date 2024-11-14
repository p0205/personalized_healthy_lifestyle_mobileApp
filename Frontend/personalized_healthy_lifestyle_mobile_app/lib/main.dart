import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/search_food/blocs/search_food_bloc.dart';
import 'calories_counter_main/caloriesCounterMain.dart';

void main() {
  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider<SearchFoodBloc>(
              create: (context) =>
                  SearchFoodBloc(),
            ),

          ],
          child: const MyApp()
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CounterCounterPage(),
        );

  }
}

class CounterCounterPage extends StatelessWidget{
  const CounterCounterPage({super.key});


  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
          child: CircularPercentagePage()
      ),
    );
  }

}
