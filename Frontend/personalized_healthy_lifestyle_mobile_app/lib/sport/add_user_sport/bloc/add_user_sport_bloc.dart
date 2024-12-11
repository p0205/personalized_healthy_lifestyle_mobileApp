import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_generator/calories_counter/repository/user_repository.dart';
import 'package:schedule_generator/sport/sport_repository/sport_repository.dart';

import '../../sport_models/sport.dart';



part 'add_user_sport_event.dart';
part 'add_user_sport_state.dart';

class AddUserSportBloc extends Bloc<AddUserSportEvent,AddUserSportState>{

  final SportRepository sportRepository = SportRepository();
  final UserRepository userRepository = UserRepository();
  final Sport sport;
  final int userId;



  AddUserSportBloc({required this.sport,required this.userId})
      : super(AddUserSportState(
    userId: userId, sportId: sport.id!,
  )) {
    on<DurationInHoursSelected>(_onDurationInHoursSelected);
    on<DurationInMinutesSelected>(_onDurationInMinutesSelected);
    on<UserInput>(_onUserInput);
    on<CalculateBtnClicked>(_onCalculateBtnClicked);
    on<DisposeCalculation>(_onDisposeCalculation);
    on<AddSportBtnClicked>(_onAddMeal);
  }

  Future<void> _onDurationInHoursSelected(
      DurationInHoursSelected event,
      Emitter<AddUserSportState> emit
      ) async {
    emit(state.copyWith(isDurationInHoursSelected: true));
  }

  Future<void> _onDurationInMinutesSelected(
      DurationInMinutesSelected event,
      Emitter<AddUserSportState> emit
      ) async {
    emit(state.copyWith(isDurationInHoursSelected: false));
  }


  Future<void> _onUserInput(
      UserInput event,
      Emitter<AddUserSportState> emit
      )  async {
    double? durationInHours;

    if(!state.isDurationInHoursSelected) {
      durationInHours = event.userInput/60;
    }else{
      durationInHours = event.userInput;
    }

    emit(state.copyWith(userId: userId, sportId: sport.id, durationInHours: durationInHours));
  }

  Future<void> _onCalculateBtnClicked(
      CalculateBtnClicked event,
      Emitter<AddUserSportState> emit
      ) async {


  }

  Future<void> _onDisposeCalculation(
      DisposeCalculation event,
      Emitter<AddUserSportState> emit
      ) async {
    emit(state.copyWith(isCalculated: false));
  }


  Future<void> _onAddMeal(
      AddSportBtnClicked event,
      Emitter<AddUserSportState> emit
      ) async {
    try{
      await mealRepository.addUserMeal(state.userId, event.mealType, double.parse(state.amountIntakeInGrams!.toStringAsFixed(2)) , double.parse(state.carbsIntake!.toStringAsFixed(2)),  double.parse(state.proteinIntake!.toStringAsFixed(2)),  double.parse(state.fatIntake!.toStringAsFixed(2)),  double.parse(state.energyIntake!.toStringAsFixed(2)), state.mealId);
      emit(state.copyWith(status: AddMealStatus.mealAdded));
    }catch(e){
      emit(state.copyWith(status: AddMealStatus.failure, message: e.toString()));
    }
  }
}