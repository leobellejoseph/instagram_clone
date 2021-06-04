import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram_clone/cubit/cubits.dart';
import 'package:instagram_clone/screens/feed/bloc/feed_bloc.dart';
import 'package:instagram_clone/widgets/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FeedScreen extends StatefulWidget {
  static const id = 'feed';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController
      ..addListener(
        () {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange &&
              context.read<FeedBloc>().state.status != FeedStatus.paginating) {
            context.read<FeedBloc>().add(FeedPaginatePost());
          }
        },
      );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialogue(content: state.failure.message),
          );
        } else if (state.status == FeedStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: const Duration(seconds: 1),
              content: const Text('Fetching..'),
            ),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          progressIndicator: SpinKitCircle(color: Colors.amber),
          inAsyncCall: state.status == FeedStatus.loading,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                if (state.posts.isEmpty && state.status == FeedStatus.loaded)
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.blueAccent),
                    onPressed: () =>
                        context.read<FeedBloc>().add(FeedFetchPost()),
                  ),
              ],
              title: const Text('Instagram'),
            ),
            body: _buildBody(state),
          ),
        );
      },
    );
  }

  Widget _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:

      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPost());
            return true;
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              final likedPostsState = context.watch<LikedPostsCubit>().state;
              final isLiked = likedPostsState.likedPostIds.contains(post.id);
              final recentlyLiked =
                  likedPostsState.recentlyLikedPostIds.contains(post.id);
              return PostView(
                isLiked: isLiked,
                post: post,
                recentlyLiked: recentlyLiked,
                onLike: () {
                  if (isLiked) {
                    context.read<LikedPostsCubit>().unlikedPost(post: post);
                  } else {
                    context.read<LikedPostsCubit>().likedPost(post: post);
                  }
                },
              );
            },
          ),
        );
    }
  }
}
