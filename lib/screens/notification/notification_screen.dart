import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram_clone/screens/notification/bloc/notifications_bloc.dart';
import 'package:instagram_clone/screens/notification/widgets/widgets.dart';
import 'package:instagram_clone/widgets/centered_text.dart';

class NotificationScreen extends StatelessWidget {
  static const id = 'notification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          switch (state.status) {
            case NotificationStatus.loaded:
              return ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return NotificationTile(notification: notification);
                  });
            case NotificationStatus.loading:
              return Center(child: SpinKitCircle(color: Colors.blueAccent));
            case NotificationStatus.error:
              return CenteredText(text: state.failure.message);
          }
          return Container();
        },
      ),
    );
  }
}
