import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  const ProfileButton(
      {@required this.isCurrentUser, @required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? ElevatedButton(onPressed: () {}, child: const Text('Edit Profile'))
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                onPrimary: isFollowing ? Colors.black : Colors.white,
                primary: isFollowing
                    ? Colors.grey[300]
                    : Theme.of(context).primaryColor),
            onPressed: () {},
            child: Text(isFollowing ? 'unfollow' : 'follow'),
          );
  }
}
