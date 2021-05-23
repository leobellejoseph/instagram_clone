part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final User user;
  final List<Post> posts;
  final bool isCurrentUser;
  final bool isGridView;
  final bool isFollowing;
  final ProfileStatus status;
  final Failure failure;
  const ProfileState({
    @required this.user,
    @required this.isCurrentUser,
    @required this.isGridView,
    @required this.isFollowing,
    @required this.status,
    @required this.failure,
    @required this.posts,
  });

  factory ProfileState.initial() => const ProfileState(
        user: User.empty,
        isCurrentUser: false,
        isGridView: true,
        isFollowing: false,
        status: ProfileStatus.initial,
        failure: Failure(),
        posts: [],
      );

  ProfileState copyWith({
    User user,
    bool isCurrentUser,
    bool isGridView,
    bool isFollowing,
    ProfileStatus status,
    Failure failure,
    List<Post> posts,
  }) =>
      ProfileState(
        user: user ?? this.user,
        isGridView: isGridView ?? this.isGridView,
        isCurrentUser: isCurrentUser ?? this.isCurrentUser,
        isFollowing: isFollowing ?? this.isFollowing,
        status: status ?? this.status,
        failure: failure ?? this.failure,
        posts: posts ?? this.posts,
      );

  @override
  List<Object> get props => [
        this.user,
        this.isCurrentUser,
        this.isGridView,
        this.isFollowing,
        this.status,
        this.failure,
        this.posts,
      ];
}
