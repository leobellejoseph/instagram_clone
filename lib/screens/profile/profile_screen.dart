import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram_clone/blocs/auth/auth_bloc.dart';
import 'package:instagram_clone/cubit/cubits.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'package:instagram_clone/widgets/widgets.dart';
import 'widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;
  const ProfileScreenArgs({@required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const id = 'profile';
  ProfileScreen();
  static Route route({@required ProfileScreenArgs args}) => MaterialPageRoute(
        settings: const RouteSettings(name: ProfileScreen.id),
        builder: (context) => BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
            likedPostsCubit: context.read<LikedPostsCubit>(),
          )..add(ProfileLoadUser(userId: args.userId)),
          child: ProfileScreen(),
        ),
      );

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        return Scaffold(
          appBar: AppBar(
            title: Text(state.user.username),
            actions: [
              if (state.isCurrentUser)
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    context.read<LikedPostsCubit>().clearAllLikedPosts();
                  },
                ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return Center(child: SpinKitCircle(color: Colors.blueAccent));
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
            return true;
          },
          child: CustomScrollView(
            slivers: [
              _profileView(state),
              _contentView(state),
              state.isGridView ? _gridView(state) : _listView(state),
            ],
          ),
        );
    }
  }

  Widget _profileView(ProfileState state) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: Row(
              children: [
                UserProfileImage(
                    radius: 40, profileImageUrl: state.user.profileImageUrl),
                ProfileStats(
                  isCurrentUser: state.isCurrentUser,
                  isFollowing: state.isFollowing,
                  posts: state.posts.length,
                  followers: state.user.followers,
                  following: state.user.following,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ProfileInfo(
              username: state.user.username,
              bio: state.user.bio,
            ),
          )
        ],
      ),
    );
  }

  Widget _contentView(ProfileState state) {
    return SliverToBoxAdapter(
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 3,
        tabs: [
          Tab(icon: Icon(Icons.grid_on, size: 28)),
          Tab(icon: Icon(Icons.list, size: 28))
        ],
        onTap: (index) => context
            .read<ProfileBloc>()
            .add(ProfileToggleGridView(isGridView: index == 0)),
      ),
    );
  }

  Widget _listView(ProfileState state) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final Post post = state.posts[index];
          final likedPostsState = context.watch<LikedPostsCubit>().state;
          final isLiked = likedPostsState.likedPostIds.contains(post.id);
          // final recentlyLiked =
          //     likedPostsState.recentlyLikedPostIds.contains(post.id);
          return PostView(
            post: post,
            isLiked: isLiked,
            //recentlyLiked: recentlyLiked,
            onLike: () {
              if (isLiked) {
                context.read<LikedPostsCubit>().unlikedPost(post: post);
              } else {
                context.read<LikedPostsCubit>().likedPost(post: post);
              }
            },
          );
        },
        childCount: state.posts.length,
      ),
    );
  }

  Widget _gridView(ProfileState state) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final Post post = state.posts[index];
          return GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(CommentsScreen.id,
                arguments: CommentsScreenArgs(post: post)),
            child: Padding(
              padding: const EdgeInsets.all(2.5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                    errorWidget: (context, url, error) => Icon(
                          Icons.image_sharp,
                          size: 100,
                          color: Colors.grey[500],
                        ),
                    progressIndicatorBuilder: (context, url, progress) =>
                        SpinKitFadingCircle(color: Colors.amber),
                    imageUrl: post.imageUrl,
                    fit: BoxFit.cover),
              ),
            ),
          );
        },
        childCount: state.posts.length,
      ),
    );
  }
}
