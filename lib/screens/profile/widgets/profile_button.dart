import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/repositories/repositories.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  const ProfileButton(
      {@required this.isCurrentUser, @required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? ElevatedButton(
            onPressed: () => Navigator.pushNamed(
                  context,
                  EditProfileScreen.id,
                  arguments: EditProfileScreenArgs(context: context),
                ),
            child: const Text('Edit Profile'))
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                onPrimary: isFollowing ? Colors.black : Colors.white,
                primary: isFollowing
                    ? Colors.grey[300]
                    : Theme.of(context).primaryColor),
            onPressed: () {
              isFollowing
                  ? context.read<ProfileBloc>().add(ProfileUnfollowUser())
                  : context.read<ProfileBloc>().add(ProfileFollowUser());
            },
            child: Text(isFollowing ? 'unfollow' : 'follow'),
          );
  }
}
