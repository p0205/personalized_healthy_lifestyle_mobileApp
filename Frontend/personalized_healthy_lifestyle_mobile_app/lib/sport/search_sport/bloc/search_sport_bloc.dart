
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:equatable/equatable.dart';
import 'package:schedule_generator/sport/sport_repository/sport_repository.dart';

import '../../sport_models/sport.dart';

part 'search_sport_state.dart';
part 'search_sport_event.dart';

class SearchSportBloc extends Bloc<SearchSportEvent,SearchSportState>{

  final SportRepository sportRepository = SportRepository();

  SearchSportBloc()
      : super(const SearchSportState()) {
    on<SearchQueryChanged>(_searchMatchingFood,
        transformer: debounce(const Duration(milliseconds: 500)));

    on<SportSelected>(_onSelectFood);

    on<BackToSearchSportPage>(_backToSearchFoodPage);
  }


  Future<void> _searchMatchingFood(
      SearchQueryChanged event,
      Emitter<SearchSportState> emit
      ) async {
    if(event.query.length > 3){
      try{
        emit(state.copyWith(status: SearchSportStatus.loading));
        final sports = await sportRepository.searchMatchingSport(event.query);
        emit(state.copyWith(status: SearchSportStatus.sportsLoaded, sports: sports));
      }catch(e)
      {
        emit(state.copyWith(status: SearchSportStatus.failure , message: e.toString()));
      }
    }else{
      emit(state.copyWith(status : SearchSportStatus.initial , sports: []));
    }
  }

  EventTransformer<Event> debounce<Event>(Duration duration){
    return (event,mapper) => event.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onSelectFood(SportSelected event, Emitter<SearchSportState> emit) async {
    emit(state.copyWith(status:SearchSportStatus.loading));

    try{
      final sport = await sportRepository.getSport(event.id);
      emit(state.copyWith(status: SearchSportStatus.selected, selectedSport: sport));
    }catch(e){
      emit(state.copyWith(status: SearchSportStatus.failure, message: e.toString()));
    }
  }

  Future<void> _backToSearchFoodPage(BackToSearchSportPage event, Emitter<SearchSportState> emit) async {
    emit(state.copyWith(status:SearchSportStatus.selected));
  }
}
