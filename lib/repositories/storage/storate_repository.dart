import 'dart:io';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'base_storage_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository extends BaseStorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<String> _uploadImage({
    @required File image,
    @required String ref,
  }) async {
    final String downloadUrl =
        await _firebaseStorage.ref(ref).putFile(image).then(
              (snap) => snap.ref.getDownloadURL(),
            );
    return downloadUrl;
  }

  @override
  Future<String> uploadProfileImage({String url, File image}) async {
    var imageId = Uuid().v4();
    //update user profile image.
    if (url.isNotEmpty) {
      final exp = RegExp(r'userProfile_(.*).jpg');
      imageId = exp.firstMatch(url)[1];
    }
    final String downloadUrl = await _uploadImage(
        image: image, ref: 'images/users/userProfile_$imageId.jpg');
    return downloadUrl;
  }

  @override
  Future<String> uploadPostImage({File image}) async {
    final imageId = Uuid().v4;
    final String downloadUrl = await _uploadImage(
        image: image, ref: 'images/posts/post_$imageId.jpeg');
    return downloadUrl;
  }
}
