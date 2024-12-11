part of 'sport_main_bloc.dart';


enum SportMainStatus{
  initial,
  loading,
  noRecordFound,
  sportListLoaded,
  sportListReloaded,
  addSportBtnClicked,
  sportDeleted,
}


extension SportMainStateX on SportMainState{
  bool get isInitial => this == SportMainStatus.initial;
  bool get isLoading => this == SportMainStatus.loading;
  bool get isNoRecordFound => this == SportMainStatus.noRecordFound;
  bool get isSportListLoaded => this == SportMainStatus.sportListLoaded;
  bool get sportListReloaded => this == SportMainStatus.sportListReloaded;
  bool get isAddSportBtnClicked => this == SportMainStatus.addSportBtnClicked;
  bool get isDeleteSport => this == SportMainStatus.sportDeleted;
}

class SportMainState extends Equatable{
  final Map<String, List<UserSport>?> sportList;
  final SportMainStatus status;
  final SportSummary? sportSummary;

  const SportMainState({
    this.sportList = const {},
    this.status = SportMainStatus.initial,
    this.sportSummary,
  });

  @override
  List<Object?> get props => [status,sportList,sportSummary];

  SportMainState copyWith({
    Map<String, List<UserSport>?>? sportList,
    SportMainStatus? status,
    SportSummary? sportSummary
  }){
    return SportMainState(
      status: status ?? this.status,
      sportList: sportList ?? this.sportList,
      sportSummary: sportSummary ?? this.sportSummary,
    );
  }

}
