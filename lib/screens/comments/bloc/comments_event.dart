part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class CommentsFetchComments extends CommentsEvent {
  final Post post;
  CommentsFetchComments({@required this.post});

  @override
  List<Object> get props => [this.post];
}

class CommentsUpdateComments extends CommentsEvent {
  final List<Comment> comments;
  const CommentsUpdateComments({@required this.comments});

  @override
  List<Object> get props => [this.comments];
}

class CommentsPostComments extends CommentsEvent {
  final String content;
  const CommentsPostComments({@required this.content});

  @override
  List<Object> get props => [this.content];
}
