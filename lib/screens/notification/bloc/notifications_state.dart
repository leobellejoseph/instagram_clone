part of 'notifications_bloc.dart';

enum NotificationStatus { initial, loading, loaded, success, error }

class NotificationsState extends Equatable {
  final List<Notif> notifications;
  final NotificationStatus status;
  final Failure failure;

  NotificationsState copyWith({
    final List<Notif> notifications,
    final NotificationStatus status,
    final Failure failure,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  const NotificationsState({
    @required this.notifications,
    @required this.status,
    @required this.failure,
  });

  factory NotificationsState.initial() => NotificationsState(
        notifications: [],
        status: NotificationStatus.initial,
        failure: Failure(),
      );

  @override
  List<Object> get props => [this.notifications, this.status, this.failure];
}
