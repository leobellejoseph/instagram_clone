import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/models/model.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({@required String userId});
  Future<void> updateUser({@required User user});
  Future<List<User>> searchUsers({String query});
  void followUser({String userId, String followerUserId});
  void unFollowUser({String userId, String unfollowerUserId});
  Future<bool> isFollowing({String userId, String otherUserId});
}
