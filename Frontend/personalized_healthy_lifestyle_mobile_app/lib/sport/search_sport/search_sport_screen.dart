
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/sport/search_sport/bloc/search_sport_bloc.dart';
import 'package:schedule_generator/user/blocs/user_state.dart';

import '../../user/blocs/user_bloc.dart';


class SearchSportScreen extends StatelessWidget {
  const SearchSportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sport'),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: DebouncedSearchBar(),
      ),
    );
  }
}

class DebouncedSearchBar extends StatefulWidget {
  const DebouncedSearchBar({super.key});


  @override
  _DebouncedSearchBarState createState() => _DebouncedSearchBarState();
}

class _DebouncedSearchBarState extends State<DebouncedSearchBar> {

  final SearchController _searchController = SearchController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return SearchAnchor(
      searchController: _searchController,
      builder: (BuildContext context, SearchController controller) {

        return SearchBar(
          key: UniqueKey(),
          controller: controller,
          leading: const Icon(Icons.search),
          hintText: "Search for a sport",
          onTap: () {
            controller.openView();
          },
        );
      },
      suggestionsBuilder: (context, controller) async {
        final model = BlocProvider.of<SearchSportBloc>(context);
        model.add(
          SearchQueryChanged(query: controller.text),);
        return [
          BlocConsumer<SearchSportBloc, SearchSportState>(
            builder: (context,state){
              if (state.status == SearchSportStatus.loading){
                return  const Center(child: CircularProgressIndicator());
              }
              if(state.status == SearchSportStatus.sportsLoaded && state.sports != null){
                if(state.sports!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(child: Text("No results found")),
                  ) ;
                }

                return ListView(
                  shrinkWrap: true, // Ensures the ListView takes only necessary space
                  children: state.sports!.map((result) {
                    return ListTile(
                      title: Text(result.name),
                      trailing: Text(
                        result.caloriesBurntPerHourPerKg != null
                            ? "${result.caloriesBurntPerHourPerKg?.toStringAsFixed(2)} cals/h/kg"
                            : "",
                        style: const TextStyle(fontSize: 15),
                      ),
                      onTap: () async {
                        model.add(SportSelected(id: result.id!));
                      },
                    );
                  }).toList(),
                );


              }

              if(state.status == SearchSportStatus.failure){
                return Text("Something went wrong...Please try again. \nError: ${state.message}");
              }
             return Container();
            }, listener: (context, state) {
            // final userState = BlocProvider.of<UserBloc>(context).state;
            //
            // int userId;
            // if(userState is LoginSuccess){
            //   userId = userState.userId;
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) =>
            //       // BlocProvider.value(
            //       // value: BlocProvider.of<SearchFoodBloc>(context),
            //       // child:
            //
            //       FoodDetailsPage(meal: state.selectedFood!, mealType: widget.mealType, userId: userId),
            //     ),
            //     // )
            //   );
            // }
          },
            // listenWhen: (context,state){
              // return (state.status == SearchFoodStatus.selected && state.selectedFood!=null);
            // },
          )];
      },
    );

  }
}
