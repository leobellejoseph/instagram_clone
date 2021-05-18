import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/blocs/auth/auth_bloc.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/widgets/error_dialogue.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:instagram_clone/widgets/widgets.dart';
import 'widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const id = 'profile';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialogue(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state.status == ProfileStatus.initial,
          child: Scaffold(
            appBar: AppBar(
              title: Text(state.user.username),
              actions: [
                if (state.isCurrentUser)
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => context.read<AuthBloc>().add(
                          AuthLogoutRequested(),
                        ),
                  ),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                        child: Row(
                          children: [
                            UserProfileImage(
                                radius: 40,
                                profileImageUrl: state.user.profileImageUrl),
                            ProfileStats(
                              isCurrentUser: state.isCurrentUser,
                              isFollowing: state.isFollowing,
                              posts: 0,
                              followers: state.user.followers,
                              following: state.user.following,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: ProfileInfo(
                          username: state.user.username,
                          bio: state.user.bio,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
