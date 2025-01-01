
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/sport/sport_models/sport_summary.dart';
import 'package:schedule_generator/sport/sport_models/user_sport.dart';
import '../../../common_widgets/donut_chart.dart';
import '../../search_sport/search_sport_screen.dart';
import '../blocs/sport_main_bloc.dart';

class SportMainPage extends StatefulWidget{



  const SportMainPage({super.key});

  @override
  State<SportMainPage> createState() => _SportMainPageState();
}

class _SportMainPageState extends State<SportMainPage> {
  @override
  Widget build(BuildContext context) {

        return Scaffold(
            appBar: AppBar(
              title: const Text("Sport Summary",textAlign: TextAlign.center,),
              backgroundColor: Colors.blueAccent,
              titleTextStyle: const TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 30.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<SportMainBloc,SportMainState>(
                  builder: (BuildContext context, SportMainState state) {

                    final model = context.read<SportMainBloc>();
                    final sportList = model.state.sportList;
                    final summary = model.state.sportSummary;
                    final List<String> sectionOrder = [];
                    sportList.forEach((key, value) {
                      sectionOrder.add(key); });
                    if (state.status == SportMainStatus.loading) {
                      return  const Padding(
                       padding: EdgeInsets.all(10.0),
                       child: CircularProgressIndicator()
                      );
                    }

                    if(state.status == SportMainStatus.noRecordFound){
                      return Column(
                        children: [
                          Text(
                            state.dateString!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Itim',
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(child: Text("No results found")),
                          ),
                          ElevatedButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchSportScreen(date: state.dateString!),
                              ),
                            );
                          },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,

                                padding: const EdgeInsets.all(10),
                              ),
                              child: const Text("Add New Sport"))
                        ],
                      );
                    }

                  return Column(
                    children: [
                      Text(
                        summary!.date,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Itim',
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Column(
                          children: [
                          CaloriesChart(summary: summary),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 8.0),
                                child:  Text(
                                  "Workout List",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              ElevatedButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchSportScreen(date: summary.date),
                                  ),
                                );
                              },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(10),
                                  ),
                                  child: const Icon(Icons.add))
                            ],
                          ),

                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: summary.calsBurntByType.length,
                              itemBuilder: (context,index){
                                final String sportType = sectionOrder[index];  // Access the section name from predefined order
                                List<UserSport>? sports = sportList[sportType];  // Get the meals for this section
                                double totalCalsBurnt = summary.calsBurntByType[sportType]!;
                                return SportCard(
                                  totalCalsBurnt: totalCalsBurnt,
                                  sportType: sportType, // For each mealType, has one FoodIntake card
                                  sports: sports,
                                );
                              })
                          ],
                        )



                    ],
                  );
                },
              ),
              ),
            )
        );
  }
}

class CaloriesChart extends StatelessWidget {

  const CaloriesChart({
    super.key,
    required this.summary
  });

  final SportSummary summary;


  @override
  Widget build(BuildContext context) {
    List<ChartData> calsByTypeData = [];


    int index = 0;
    int total = summary.calsBurntByType.length;

    summary.calsBurntByType.forEach((name,value){
      calsByTypeData.add(ChartData(
          name: name,
          value: value,
          color: getColorByIndex(index++, total)));
    });

    return Center(
      child: DonutChart(
        dataList: calsByTypeData,
        donutSizePercentage: 0.7,
        columnLabel: "Calories Burnt (kcal)",
        containerHeight: 240,
        centerText:  "${summary.totalCalsBurnt.toStringAsFixed(2)} kcal\nburnt",
      ),
    );
  }
}

Color getColorByIndex(int index, int total) {
  // Generate a color based on the index of the category
  double hue = (index * 360 / total) % 360; // Map index to hue in color wheel
  return HSVColor.fromAHSV(1.0, hue, 0.7, 0.7).toColor(); // Use a fixed saturation and value
}

class SportCard extends StatefulWidget {

  final double totalCalsBurnt;
  final String sportType;
  final List<UserSport>? sports;

  const SportCard({
    super.key,
    required this.sportType,
    required this.totalCalsBurnt,
    this.sports,
  });

  @override
  State<SportCard> createState() => _SportCardState();
}

class _SportCardState extends State<SportCard> {

  @override
  Widget build(BuildContext context) {
    String totalCalsBurntString = widget.totalCalsBurnt.toStringAsFixed(2);
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
                Expanded(
                  flex: 6 ,
                  child: Text(
                      widget.sportType,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    "$totalCalsBurntString kcal",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),


              ],
            ),
            const SizedBox(height: 10),

            Column(
              children: widget.sports!.map((sport) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    sport.sportName,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                  subtitle: Text("${sport.durationInHours.toStringAsFixed(2)} hour(s)"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // To keep the row compact
                    children: [
                      Text("${sport.caloriesBurnt.toStringAsFixed(2)} kcal"),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                                child: AlertDialog(
                                  content: const Text(
                                      "Confirm to delete This Sport? ",
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          child: const Text("OK"),
                                          onPressed: () {
                                            final sportMainBloc = context.read<SportMainBloc>();
                                            sportMainBloc.add(DeleteSportBtnClicked(userSportId: sport.id));

                                            Navigator.pop(context);
                                          },
                                        ),
                                        ElevatedButton(
                                          child: const Text("CANCEL"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          );

                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          ],

        ),

      ),
    );
  }
}



