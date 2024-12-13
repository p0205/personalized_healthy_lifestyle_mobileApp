
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/user/blocs/user_state.dart';

import '../../../user/blocs/user_bloc.dart';
import '../../add_user_meal/screen/food_details_page.dart';
import '../blocs/search_meal_bloc.dart';
import '../../repository/meal_repository.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, required this.mealType});
  final String mealType;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MealApiRepository(),
      child: BlocProvider(
        create: (context) => SearchFoodBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Food'),
            backgroundColor: Colors.blueAccent,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: DebouncedSearchBar(mealType: mealType),
          ),
        ),
      ),
    );
  }
}

class DebouncedSearchBar extends StatefulWidget {
  const DebouncedSearchBar({required this.mealType});
  final String mealType;

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
            hintText: "Search for a food",
            onTap: () {
              controller.openView();
            },
          );
        },
        suggestionsBuilder: (context, controller) async {
          final model = BlocProvider.of<SearchFoodBloc>(context);
            model.add(
              SearchQueryChanged(query: controller.text),);
          return [
            BlocConsumer<SearchFoodBloc, SearchFoodState>(
              builder: (context,state){
                  if(state.status == SearchFoodStatus.foodsLoaded && state.foods != null){
                    if(state.foods!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Center(child: Text("No results found")),
                      ) ;
                    }

                    return ListView(
                      shrinkWrap: true, // Ensures the ListView takes only necessary space
                      children: state.foods!.map((result) {
                        return ListTile(
                          title: Text(result.name),
                          trailing: Text(
                            result.energyPer100g != null
                                ? "${result.energyPer100g?.toStringAsFixed(2)} cals"
                                : "",
                            style: const TextStyle(fontSize: 15),
                          ),
                          onTap: () async {
                           model.add(FoodSelected(id: result.id!));
                          },
                        );
                      }).toList(),
                    );


                  } else if (state.status == SearchFoodStatus.loading){
                    return  const Center(child: CircularProgressIndicator());
                  }
                  return Container();
              }, listener: (context, state) {
                  final userState = BlocProvider.of<UserBloc>(context).state;

                  int userId;
                  if(userState is LoginSuccess){
                    userId = userState.userId;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        // BlocProvider.value(
                        // value: BlocProvider.of<SearchFoodBloc>(context),
                        // child:

                        FoodDetailsPage(meal: state.selectedFood!, mealType: widget.mealType, userId: userId),
                      ),
                      // )
                    );
                  }
            },
              listenWhen: (context,state){
                return (state.status == SearchFoodStatus.selected && state.selectedFood!=null);
              },
          )];
        },
      );
      
  }
}
