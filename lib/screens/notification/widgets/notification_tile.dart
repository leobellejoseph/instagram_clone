import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram_clone/enums/notif_type.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/screens/screens.dart';
import 'package:instagram_clone/widgets/widgets.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final Notif notification;
  const NotificationTile({@required this.notification});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserProfileImage(
          radius: 18, profileImageUrl: notification.fromUser.profileImageUrl),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: notification.fromUser.username,
                style: TextStyle(fontWeight: FontWeight.w600)),
            const TextSpan(text: ' '),
            TextSpan(text: _getText(notification)),
          ],
        ),
      ),
      subtitle: Text(
        DateFormat.yMd().add_jm().format(notification.date),
        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        ProfileScreen.id,
        arguments: ProfileScreenArgs(userId: notification.fromUser.id),
      ),
      trailing: _getTrailing(context, notification),
    );
  }

  Widget _getTrailing(BuildContext context, Notif notification) {
    if (notification.type == NotifType.like ||
        notification.type == NotifType.comment) {
      return GestureDetector(
        child: CachedNetworkImage(
          height: 60,
          width: 60,
          fit: BoxFit.cover,
          imageUrl: notification.post.imageUrl,
          placeholder: (_, __) => SpinKitCircle(),
        ),
        onTap: () => Navigator.of(context).pushNamed(
          CommentsScreen.id,
          arguments: CommentsScreenArgs(post: notification.post),
        ),
      );
    } else if (notification.type == NotifType.follow) {
      return const SizedBox(
        height: 60,
        width: 60,
        child: Icon(Icons.person_add),
      );
    }
    return SizedBox.shrink();
  }

  String _getText(Notif notification) {
    switch (notification.type) {
      case NotifType.follow:
        return 'followed your post.';
      case NotifType.comment:
        return 'commented on your post.';
      case NotifType.like:
        return 'liked your post.';
      default:
        return '';
    }
  }
}
