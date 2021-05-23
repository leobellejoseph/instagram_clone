import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram_clone/screens/feed/bloc/feed_bloc.dart';
import 'package:instagram_clone/widgets/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FeedScreen extends StatefulWidget {
  static const id = 'feed';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialogue(content: state.failure.message),
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
          child: ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return PostView(isLiked: false, post: post);
            },
          ),
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPost());
            return true;
          },
        );
    }
  }
}
