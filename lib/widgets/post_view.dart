import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'package:instagram_clone/widgets/user_profile_image.dart';
import 'package:instagram_clone/extensions/extensions.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final Function onLike;
  final bool recentlyLiked;
  PostView({
    @required this.post,
    @required this.isLiked,
    @required this.onLike,
    this.recentlyLiked,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              ProfileScreen.id,
              arguments: ProfileScreenArgs(userId: post.author.id),
            ),
            child: Row(
              children: [
                UserProfileImage(
                  radius: 18,
                  profileImageUrl: post.author.profileImageUrl,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(post.author.username,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: onLike,
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 300,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: CachedNetworkImage(
                  errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 200,
                        color: Colors.grey[400],
                      ),
                  progressIndicatorBuilder: (context, url, progress) =>
                      SpinKitFadingCircle(color: Colors.amber),
                  imageUrl: post.imageUrl,
                  fit: BoxFit.cover),
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              splashRadius: 20,
              splashColor: Colors.blueAccent,
              icon: isLiked
                  ? const Icon(Icons.favorite_rounded, color: Colors.red)
                  : const Icon(Icons.favorite_outline, color: Colors.black),
              onPressed: onLike,
            ),
            IconButton(
              splashColor: Colors.blueAccent,
              splashRadius: 20,
              icon: Icon(Icons.comment_outlined, color: Colors.grey[800]),
              onPressed: () => Navigator.of(context).pushNamed(
                  CommentsScreen.id,
                  arguments: CommentsScreenArgs(post: post)),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${recentlyLiked ?? false ? post.likes + 1 : post.likes} likes',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: post.author.username,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: post.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                post.date.timeAgo(),
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
