import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/blocs/auth/auth_bloc.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/repositories/post/post_repository.dart';
import 'package:meta/meta.dart';

part 'liked_posts_state.dart';

class LikedPostsCubit extends Cubit<LikedPostsState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;
  LikedPostsCubit({
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _authBloc = authBloc,
        super(LikedPostsState.initial());

  void updateLikedPosts({@required Set<String> postIds}) {
    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..addAll(postIds),
      ),
    );
  }

  void likedPost({@required Post post}) {
    _postRepository.createLike(post: post, userId: _authBloc.state.user.uid);
    emit(
      state.copyWith(
          likedPostIds: Set<String>.from(state.likedPostIds)..add(post.id),
          recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
            ..add(post.id)),
    );
  }

  void unlikedPost({@required Post post}) {
    _postRepository.createLike(post: post, userId: _authBloc.state.user.uid);
    emit(
      state.copyWith(
          likedPostIds: Set<String>.from(state.likedPostIds)..remove(post.id),
          recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
            ..remove(post.id)),
    );
  }

  void clearAllLikedPosts() {
    emit(LikedPostsState.initial());
  }
}
