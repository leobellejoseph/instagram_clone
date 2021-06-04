import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/blocs/blocs.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/repositories/post/post_repository.dart';
import 'package:instagram_clone/screens/comments/bloc/comments_bloc.dart';
import 'package:instagram_clone/widgets/widgets.dart';
import 'package:intl/intl.dart';

import '../screens.dart';

class CommentsScreenArgs {
  final Post post;
  const CommentsScreenArgs({this.post});
}

class CommentsScreen extends StatefulWidget {
  static const id = 'comments';
  static Route route({@required CommentsScreenArgs args}) => MaterialPageRoute(
        settings: const RouteSettings(name: CommentsScreen.id),
        builder: (context) => BlocProvider<CommentsBloc>(
          create: (_) => CommentsBloc(
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(CommentsFetchComments(post: args.post)),
          child: CommentsScreen(),
        ),
      );

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentsStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialogue(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Comments')),
          body: ListView.builder(
            padding: const EdgeInsets.only(bottom: 60),
            itemCount: state.comments.length,
            itemBuilder: (context, index) {
              final comment = state.comments[index];
              return ListTile(
                leading: UserProfileImage(
                  radius: 22,
                  profileImageUrl: comment.author.profileImageUrl,
                ),
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: comment.author.username,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: comment.content),
                    ],
                  ),
                ),
                subtitle: Text(
                  DateFormat.yMd().add_jm().format(comment.date),
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  ProfileScreen.id,
                  arguments: ProfileScreenArgs(userId: comment.author.id),
                ),
              );
            },
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentEditingController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration:
                            InputDecoration(hintText: 'Write a comment...'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        final content = _commentEditingController.text.trim();
                        if (content.isNotEmpty) {
                          context.read<CommentsBloc>().add(
                                CommentsPostComments(content: content),
                              );
                          _commentEditingController.clear();
                        }
                      },
                    ),
                  ],
                ),
                if (state.status == CommentsStatus.submitting)
                  LinearProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
