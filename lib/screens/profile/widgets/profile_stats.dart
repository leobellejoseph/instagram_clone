import 'package:flutter/material.dart';
import 'widgets.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int followers;
  final int following;
  const ProfileStats({
    @required this.isCurrentUser,
    @required this.isFollowing,
    @required this.posts,
    @required this.followers,
    @required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Stats(count: posts.toString(), label: 'posts'),
              _Stats(count: followers.toString(), label: 'followers'),
              _Stats(count: following.toString(), label: 'following'),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ProfileButton(
              isCurrentUser: isCurrentUser,
              isFollowing: isFollowing,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final String count;
  final String label;
  const _Stats({@required this.count, @required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black54),
        )
      ],
    );
  }
}
