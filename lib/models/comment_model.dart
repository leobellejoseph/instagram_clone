import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/config/paths.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:meta/meta.dart';

class Comment extends Equatable {
  final String id;
  final User author;
  final String content;
  final DateTime date;
  final String postId;

  Comment copyWith({
    final String id,
    final User author,
    final String content,
    final DateTime date,
    final String postId,
  }) {
    return Comment(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
      postId: postId ?? this.postId,
    );
  }

  const Comment({
    this.id,
    @required this.author,
    @required this.content,
    @required this.date,
    @required this.postId,
  });

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'content': content,
      'date': Timestamp.fromDate(date),
      'postId': postId,
    };
  }

  static Future<Comment> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final dynamic data = doc.data();
    final authorRef = data['author'] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Comment(
          id: doc.id,
          postId: data['postId'] ?? '',
          author: User.fromDocument(authorDoc),
          content: data['content'] ?? '',
          date: (data['date'] as Timestamp)?.toDate(),
        );
      }
    }
    return null;
  }

  @override
  List<Object> get props => [
        this.id,
        this.author,
        this.content,
        this.date,
        this.postId,
      ];
}
