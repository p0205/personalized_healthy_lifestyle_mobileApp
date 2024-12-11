
import 'package:schedule_generator/calories_counter/repository/user_data_provider.dart';

import '../search_meal/models/user.dart';

class UserRepository{

  final UserDataProvider userDataProvider = UserDataProvider();

  // Future<User> fetchUser(int id) async {
  //   print("Enter user repository...");
  //   return await userDataProvider.fetchUser(id);
  //
  // }

  Future<String> getUserWeight(int id)async{
    return await userDataProvider.getUserWeight(id);
  }
}