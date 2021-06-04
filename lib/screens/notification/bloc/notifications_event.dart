part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class NotificationsUpdateNotifications extends NotificationsEvent {
  final List<Notif> notifications;
  const NotificationsUpdateNotifications({@required this.notifications});
  @override
  List<Object> get props => [this.notifications];
}
