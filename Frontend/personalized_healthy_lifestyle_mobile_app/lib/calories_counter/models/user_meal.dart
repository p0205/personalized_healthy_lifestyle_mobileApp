class UserMeal{
  int id;
  String mealType;
  int userId;
  int mealId;
  String? date;
  String? mealName;
  double amountInGrams;
  double? calories;
  double? carbsInGrams;
  double? proteinInGrams;
  double? fatInGrams;

  UserMeal(this.id,this.mealType, this.userId,this.mealId, this.mealName, this.date, this.amountInGrams,this.calories,this.carbsInGrams,this.proteinInGrams,this.fatInGrams);

  factory UserMeal.fromJson(Map<String,dynamic> json) => UserMeal(
      json['id'],
      json['mealType'],
      json['userId'],
      json['mealId'],
      json['mealName'],
      json['date'],
      json['amountInGrams'],
      json['calories'],
      json['carbsInGrams'],
      json['proteinInGrams'],
      json['fatInGrams']
  );

  Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "mealType" : mealType,
      "userId" : userId,
      'mealId' : mealId,
      "date" : date,
      "mealName" : mealName,
      'amountInGrams': amountInGrams,
      'calories': calories,
      'carbsInGrams':carbsInGrams,
      'proteinInGrams': proteinInGrams,
      'fatInGrams': fatInGrams,
    };
  }

  static List<UserMeal> fromJsonArray(List<dynamic> jsonArray){
    return jsonArray.map((json) => UserMeal.fromJson(json)).toList();
  }
}