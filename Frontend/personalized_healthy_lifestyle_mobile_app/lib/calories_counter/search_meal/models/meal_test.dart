import 'package:test/test.dart';
import '../../models/meal.dart';
import '../food_api_index.dart';

void main(){
  group("Location", (){
    group("fromJson", (){
      test("returns correct food object",(){
        expect(
          Meal.fromJson(
              <String,dynamic>{
                "id": 12,
                "name" : "Mee goreng",
                "unitWeight": 10.5,
                "proteinPer100g": 12.5,
                "energyPer100g": 12.5,
                "fatPer100g": 12.5
              }
          ),
        isA<Meal>()
          .having((w) => w.id, "id", 12)
          .having((w)=>w.name, "name", "Mee goreng")
          .having((w)=>w.unitWeight, "unitWeight", 10.5)
          .having((w)=>w.proteinPer100g, "proteinPer100g", 12.5)
          .having((w)=>w.fatPer100g, "fatPer100g", 12.5)
          .having((w)=>w.energyPer100g, "energyPer100g", 12.5),
        );
      });
    });

    group("toJson", (){
      test("returns correct json object", (){

        final food = Meal(
          12,
          "Mee goreng",
          10.5,
          12.5,
          15.5,
          12.5,
          8.0,
        );

        final json = food.toJson();
        expect(
          json, {
          "id": 12,
          "name": "Mee goreng",
          "unitWeight": 10.5,
          "energyPer100g": 12.5,
          "carbsPer100g": 15.5,
          "proteinPer100g": 12.5,
          "fatPer100g": 8.0,
        }
        );
      });
    });
  });
}