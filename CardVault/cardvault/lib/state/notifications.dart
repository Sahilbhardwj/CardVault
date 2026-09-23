import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationMessageNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void show(String message) {
    state = message;
  }

  void clear() {
    state = null;
  }
}

final notificationMessageProvider =
    NotifierProvider<NotificationMessageNotifier, String?>(
  NotificationMessageNotifier.new,
);