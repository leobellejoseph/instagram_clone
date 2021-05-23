import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/repositories/user/base_user_repository.dart';
import 'package:instagram_clone/config/paths.dart';
import 'package:meta/meta.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;
  UserRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Future<User> getUserWithId({@required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({@required User user}) async {
    print(user.bio);
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<List<User>> searchUsers({String query}) async {
    final userSnap = await _firebaseFirestore
        .collection(Paths.users)
        .where('username', isLessThanOrEqualTo: query)
        .get();
    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  void followUser({@required String userId, @required String followerUserId}) {
    //add followUser to userFollowing
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(followerUserId)
        .set({});

    //add user to followers's userFollowers
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(followerUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .set({});
  }

  @override
  Future<bool> isFollowing(
      {@required String userId, @required String otherUserId}) async {
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }

  @override
  void unFollowUser(
      {@required String userId, @required String unfollowerUserId}) {
    //remove unfollow from users following
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowerUserId)
        .delete();
    //remove user from unfollowusers userfollowers
    _firebaseFirestore
        .collection(Paths.followers)
        .doc(unfollowerUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .delete();
  }
}
