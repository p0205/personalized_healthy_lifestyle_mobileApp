import 'package:schedule_generator/add_meal/repository/user_data_provider.dart';

import '../../search_food/models/user.dart';

class UserRepository{
  final UserDataProvider userDataProvider = UserDataProvider();

  Future<User> fetchUser(int id) async {
    print("Enter user repository...");
    return await userDataProvider.fetchUser(id);

  }
}