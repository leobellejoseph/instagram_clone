import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/blocs/auth/auth_bloc.dart';
import 'package:instagram_clone/models/model.dart';
import 'package:instagram_clone/repositories/notification/notification_repository.dart';
import 'package:meta/meta.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _notificationRepository;
  final AuthBloc _authBloc;
  StreamSubscription<List<Future<Notif>>> _notificationSubscription;
  NotificationsBloc(
      {@required NotificationRepository notificationRepository,
      @required AuthBloc authBloc})
      : _notificationRepository = notificationRepository,
        _authBloc = authBloc,
        super(NotificationsState.initial()) {
    _notificationSubscription?.cancel();
    _notificationSubscription = _notificationRepository
        .getUserNotifications(userId: _authBloc.state.user.uid)
        .listen((notifications) async {
      final allNotifications = await Future.wait(notifications);
      add(NotificationsUpdateNotifications(notifications: allNotifications));
    });
  }

  @override
  Future<void> close() {
    _notificationSubscription.cancel();
    return super.close();
  }

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    if (event is NotificationsUpdateNotifications) {
      yield* _mapNotificationUpdateNotificationToState(event);
    }
  }

  Stream<NotificationsState> _mapNotificationUpdateNotificationToState(
      NotificationsUpdateNotifications event) async* {
    yield state.copyWith(status: NotificationStatus.loading);
    try {
      yield state.copyWith(
          status: NotificationStatus.loaded,
          notifications: event.notifications);
    } on Failure catch (e) {
      yield state.copyWith(
        status: NotificationStatus.error,
        failure: Failure(code: e.code, message: e.message),
      );
    }
  }
}
