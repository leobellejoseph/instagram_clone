part of 'create_post_cubit.dart';

enum CreatePostStatus { initial, submitting, success, error }

class CreatePostState extends Equatable {
  final File postImage;
  final String caption;
  final CreatePostStatus status;
  final Failure failure;
  const CreatePostState({
    @required this.postImage,
    @required this.caption,
    @required this.status,
    @required this.failure,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
      postImage: null,
      caption: '',
      status: CreatePostStatus.initial,
      failure: Failure(),
    );
  }

  CreatePostState copyWith({
    final File postImage,
    final String caption,
    final CreatePostStatus status,
    final Failure failure,
  }) {
    return CreatePostState(
      postImage: postImage ?? this.postImage,
      caption: caption ?? this.caption,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props =>
      [this.postImage, this.caption, this.status, this.failure];
}
