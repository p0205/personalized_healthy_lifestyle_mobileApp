class Food{
  int id;
  String name;
  double? unitWeight;
  double? energyPer100g;
  double? carbsPer100g;
  double? proteinPer100g;
  double? fatPer100g;

  Food(this.id, this.name,this.unitWeight,this.energyPer100g,this.carbsPer100g,this.proteinPer100g,this.fatPer100g);

  factory Food.fromJson(Map<String,dynamic> json) => Food(
      json['id'],
      json['name'],
      json['unitWeight'],
      json['energyPer100g'],
      json['carbsPer100g'],
      json['proteinPer100g'],
      json['fatPer100g']
  );

  Map<String,dynamic> toJson(){
    return{
      "id" : id,
      "name" : name,
      'unitWeight' : unitWeight,
      'energyPer100g': energyPer100g,
      'carbsPer100g': carbsPer100g,
      'proteinPer100g':proteinPer100g,
      'fatPer100g': fatPer100g,
    };
  }

  static List<Food> fromJsonArray(List<dynamic> jsonArray){
    return jsonArray.map((json) => Food.fromJson(json)).toList();
  }

}
