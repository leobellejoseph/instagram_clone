import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/config/paths.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:meta/meta.dart';

class Post extends Equatable {
  final String id;
  final User author;
  final String imageUrl;
  final String caption;
  final int likes;
  final DateTime date;

  Post copyWith({
    final String id,
    final User user,
    final String imageUrl,
    final String caption,
    final int likes,
    final DateTime date,
  }) {
    return Post(
      id: id ?? this.id,
      author: user ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      date: date ?? this.date,
    );
  }

  const Post({
    this.id,
    @required this.author,
    @required this.imageUrl,
    @required this.caption,
    @required this.likes,
    @required this.date,
  });

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'imageUrl': imageUrl,
      'caption': caption,
      'likes': likes,
      'date': Timestamp.fromDate(date),
    };
  }

  static Future<Post> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final dynamic data = doc.data();
    final authorRef = data['author'] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Post(
          id: doc.id,
          author: User.fromDocument(authorDoc),
          imageUrl: data['imageUrl'] ?? '',
          caption: data['caption'] ?? '',
          likes: (data['likes'] ?? 0).toInt(),
          date: (data['date'] as Timestamp)?.toDate(),
        );
      }
    }
    return null;
  }

  @override
  List<Object> get props =>
      [this.id, this.author, this.imageUrl, this.caption, this.likes];
}
