import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/blocs/auth/auth_bloc.dart';
import 'package:instagram_clone/cubit/liked_posts/liked_posts_cubit.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/repositories/post/post_repository.dart';
import 'package:meta/meta.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;
  FeedBloc(
      {@required PostRepository postRepository,
      @required AuthBloc authBloc,
      @required LikedPostsCubit likedPostsCubit})
      : _postRepository = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(FeedState.initial());

  @override
  Stream<FeedState> mapEventToState(
    FeedEvent event,
  ) async* {
    if (event is FeedFetchPost) {
      yield* _mapFeedFetchPostsToState();
    } else if (event is FeedPaginatePost) {
      yield* _mapFeedPaginatePostsState();
    }
  }

  Stream<FeedState> _mapFeedFetchPostsToState() async* {
    yield state.copyWith(status: FeedStatus.loading);
    try {
      final posts =
          await _postRepository.getUserFeed(userId: _authBloc.state.user.uid);
      _likedPostsCubit.clearAllLikedPosts();
      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user.uid,
        posts: posts,
      );
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
      yield state.copyWith(posts: posts, status: FeedStatus.loaded);
    } on Failure catch (_) {
      yield state.copyWith(
        status: FeedStatus.error,
        failure: Failure(
          code: 'Feed',
          message: 'Unable to fetch feed.',
        ),
      );
    }
  }

  Stream<FeedState> _mapFeedPaginatePostsState() async* {
    yield state.copyWith(status: FeedStatus.loading);
    try {
      final lastPostID = state.posts.isNotEmpty ? state.posts.last.id : null;
      final posts = await _postRepository.getUserFeed(
          userId: _authBloc.state.user.uid, lastPostId: lastPostID);

      final updatedPosts = List<Post>.from(state.posts)..addAll(posts);

      final likedPostIds = await _postRepository.getLikedPostIds(
        userId: _authBloc.state.user.uid,
        posts: updatedPosts,
      );
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      yield state.copyWith(posts: updatedPosts, status: FeedStatus.loaded);
    } on Failure catch (_) {
      yield state.copyWith(
        status: FeedStatus.error,
        failure: Failure(
          code: 'Feed',
          message: 'Unable to fetch paginated feed.',
        ),
      );
    }
  }
}
