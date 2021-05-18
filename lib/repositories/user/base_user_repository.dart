import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/models/model.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({@required String userId});
  Future<void> updateUser({@required User user});
}
