part of 'search_sport_bloc.dart';

abstract class SearchSportEvent extends Equatable{
  const SearchSportEvent();
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchSportEvent{
  final String query;

  //constructor
  const SearchQueryChanged({required this.query});

  List<Object?> get props => [query];
}

class SportSelected extends SearchSportEvent{
  final int id;

  const SportSelected({required this.id});
}

class BackToSearchSportPage extends SearchSportEvent{
  const BackToSearchSportPage();
}

