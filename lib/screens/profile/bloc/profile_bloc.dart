import 'dart:async';
import 'package:instagram_clone/blocs/auth/auth_bloc.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  final PostRepository _postRepository;
  StreamSubscription<List<Future<Post>>> _postSubscription;

  @override
  Future<void> close() {
    _postSubscription.cancel();
    return super.close();
  }

  ProfileBloc(
      {@required UserRepository userRepository,
      @required AuthBloc authBloc,
      @required PostRepository postRepository})
      : _userRepository = userRepository,
        _authBloc = authBloc,
        _postRepository = postRepository,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    } else if (event is ProfileToggleGridView) {
      yield* _mapProfileToggleGridViewState(event);
    } else if (event is ProfileUpdatePosts) {
      yield* _mapProfileUpdatePosts(event);
    } else if (event is ProfileFollowUser) {
      yield* _mapProfileFollowUserToState();
    } else if (event is ProfileUnfollowUser) {
      yield* _mapProfileUnfollowUserToState();
    }
  }

  Stream<ProfileState> _mapProfileFollowUserToState() async* {
    try {
      _userRepository.followUser(
          userId: _authBloc.state.user.uid, followerUserId: state.user.id);

      final updatedUser =
          state.user.copyWith(followers: state.user.followers + 1);
      yield state.copyWith(user: updatedUser, isFollowing: true);
    } on Failure catch (_) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure:
            const Failure(code: 'Follow', message: 'Unable to follow user'),
      );
    }
  }

  Stream<ProfileState> _mapProfileUnfollowUserToState() async* {
    try {
      _userRepository.unFollowUser(
          userId: _authBloc.state.user.uid, unfollowerUserId: state.user.id);
      final updatedUser =
          state.user.copyWith(followers: state.user.followers - 1);
      yield state.copyWith(user: updatedUser, isFollowing: true);
    } on Failure catch (_) {
      yield (state.copyWith(
          status: ProfileStatus.error,
          failure: const Failure(
              code: 'Unfollow', message: 'Unable to unfollow user')));
    }
  }

  Stream<ProfileState> _mapProfileUpdatePosts(ProfileUpdatePosts event) async* {
    yield state.copyWith(posts: event.posts);
  }

  Stream<ProfileState> _mapProfileToggleGridViewState(
      ProfileToggleGridView event) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
      ProfileLoadUser event) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final User user =
          await _userRepository.getUserWithId(userId: event.userId);
      final bool isCurrentUser = _authBloc.state.user.uid == event.userId;
      final bool isFollowing = await _userRepository.isFollowing(
          userId: _authBloc.state.user.uid, otherUserId: event.userId);

      _postSubscription?.cancel();
      _postSubscription =
          _postRepository.getUserPosts(userId: event.userId).listen(
        (posts) async {
          final allPosts = await Future.wait(posts);
          add(ProfileUpdatePosts(posts: allPosts));
        },
      );

      yield state.copyWith(
          user: user,
          isFollowing: isFollowing,
          isCurrentUser: isCurrentUser,
          status: ProfileStatus.loaded);
    } on Failure catch (_) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure:
            const Failure(code: 'Error', message: 'Unable to load profile'),
      );
    }
  }
}
