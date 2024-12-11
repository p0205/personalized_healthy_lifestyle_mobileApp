import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../sport_models/sport_summary.dart';
import '../../sport_models/user_sport.dart';
import '../../sport_repository/sport_repository.dart';

part 'sport_main_event.dart';
part 'sport_main_state.dart';

class SportMainBloc extends Bloc<SportMainEvent,SportMainState>{
  final SportRepository sportRepository = SportRepository();
  int userId;
  DateTime date;

  SportMainBloc({required this.userId, required this.date}): super(const SportMainState(status: SportMainStatus.loading)){
    on<AddBtnClicked>(_addSportBtnClicked);
    on<LoadUserSportList>(_loadUserSportList);
    // on<ReloadSportList>(_reload);
    // on<DeleteSportBtnClicked>(_delete);
  }

  Future<void> _addSportBtnClicked(
      AddBtnClicked event,
      Emitter<SportMainState> emit
      )async{
    emit(state.copyWith(status: SportMainStatus.addSportBtnClicked));
  }

  Future<void> _loadUserSportList(
      LoadUserSportList event,
      Emitter<SportMainState> emit
      )async{
    emit(state.copyWith(status: SportMainStatus.loading, sportList: {}));
    final sportList = await sportRepository.getUserSportListByDate(userId, date);
    final SportSummary sportSummary = await sportRepository.getSportSummary(userId,date);
    if(sportList.isNotEmpty){
      emit(state.copyWith(status: SportMainStatus.sportListLoaded, sportList: sportList, sportSummary: sportSummary));
    }else{
      emit(state.copyWith(status: SportMainStatus.noRecordFound));
    }
  }

  // Future<void> _reload(
  //     ReloadSportList event,
  //     Emitter<SportMainState> emit
  //     )async{
  //   emit(state.copyWith(status: SportMainStatus.loading, mealList: {}));
  //   final mealList = await mealRepository.getUserMealListByDate(userId, date);
  //   final nutritionalSummary = await mealRepository.getNutritionalSummary(userId,date);
  //   emit(state.copyWith(status: SportMainStatus.mealListReloaded, mealList: mealList, summary: nutritionalSummary));
  // }

  // Future<void> _delete(
  //     DeleteSportBtnClicked event,
  //     Emitter<SportMainState> emit
  //     )async{
  //   emit(state.copyWith(status: SportMainStatus.loading, sportList: {}));
  //   await sportRepository.deleteUserMeal(event.userMealId);
  //   _init;
  //   print("after init");
  //   print(state.mealList.toString());
  //   emit(state.copyWith(status: SportMainStatus.mealDeleted));
  // }
}


