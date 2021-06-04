import 'package:instagram_clone/models/model.dart';

abstract class BaseNotificationRepository {
  Stream<List<Future<Notif>>> getUserNotifications({String userId});
}
