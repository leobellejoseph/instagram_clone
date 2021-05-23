part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileLoadUser extends ProfileEvent {
  final String userId;
  const ProfileLoadUser({@required this.userId});
  @override
  List<Object> get props => [this.userId];
}

class ProfileToggleGridView extends ProfileEvent {
  final bool isGridView;
  const ProfileToggleGridView({@required this.isGridView});
  @override
  List<Object> get props => [this.isGridView];
}

class ProfileUpdatePosts extends ProfileEvent {
  final List<Post> posts;
  const ProfileUpdatePosts({@required this.posts});
  @override
  List<Object> get props => [this.posts];
}

class ProfileUnfollowUser extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class ProfileFollowUser extends ProfileEvent {
  @override
  List<Object> get props => [];
}
