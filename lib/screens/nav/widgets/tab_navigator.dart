import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/blocs/auth/auth_bloc.dart';
import 'package:instagram_clone/config/custom_router.dart';
import 'package:instagram_clone/cubit/cubits.dart';
import 'package:instagram_clone/enums/bottom_nav_item.dart';
import 'package:instagram_clone/repositories/repositories.dart';
import 'package:instagram_clone/screens/create_post/cubit/create_post_cubit.dart';
import 'package:instagram_clone/screens/feed/bloc/feed_bloc.dart';
import 'package:instagram_clone/screens/notification/bloc/notifications_bloc.dart';
import 'package:instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'package:instagram_clone/screens/search/cubit/cubit/search_cubit.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;
  const TabNavigator({@required this.navigatorKey, @required this.item});
  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
              settings: RouteSettings(name: tabNavigatorRoot),
              builder: (context) => routeBuilders[initialRoute](context))
        ];
      },
      onGenerateRoute: CustomRoute.onGenerateNestedRouted,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return BlocProvider<FeedBloc>(
          create: (context) => FeedBloc(
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
            likedPostsCubit: context.read<LikedPostsCubit>(),
          )..add(FeedFetchPost()),
          child: FeedScreen(),
        );
      case BottomNavItem.search:
        return BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(
            userRepository: context.read<UserRepository>(),
          ),
          child: SearchScreen(),
        );
      case BottomNavItem.create:
        return BlocProvider<CreatePostCubit>(
          child: CreatePostScreen(),
          create: (_) => CreatePostCubit(
            postRepository: context.read<PostRepository>(),
            storageRepository: context.read<StorageRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
        );
      case BottomNavItem.notifications:
        return BlocProvider<NotificationsBloc>(
          create: (_) => NotificationsBloc(
            notificationRepository: context.read<NotificationRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: NotificationScreen(),
        );
      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            postRepository: context.read<PostRepository>(),
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
            likedPostsCubit: context.read<LikedPostsCubit>(),
          )..add(
              ProfileLoadUser(userId: context.read<AuthBloc>().state.user.uid),
            ),
          child: ProfileScreen(),
        );
      default:
        return Scaffold();
    }
  }
}
