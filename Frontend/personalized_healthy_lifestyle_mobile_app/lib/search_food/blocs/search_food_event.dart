part of 'search_food_bloc.dart';

abstract class SearchFoodEvent extends Equatable{
  const SearchFoodEvent();
  List<Object?> get props => [];

}

class SearchQueryChanged extends SearchFoodEvent{
  final String query;

  //constructor
  const SearchQueryChanged({required this.query});

  List<Object?> get props => [query];
}

class FoodSelected extends SearchFoodEvent{
  final int id;

  const FoodSelected({required this.id});
}

class BackToSearchFoodPage extends SearchFoodEvent{
  const BackToSearchFoodPage();
}

