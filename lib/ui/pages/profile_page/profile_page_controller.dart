import 'package:flutter/material.dart';
import 'package:tw_mobile/ui/pages/profile_page/notifiers/profile_page_notifiers.dart';

class ProfilePageController {
  final profileNotifier = ProfilePageNotifier();

  void updatedNotifications() {
    profileNotifier.updateNotifications();
  }

  bool getNotificationSetting() {
    return profileNotifier.notifications;
  }

  void updateAllIn() {
    profileNotifier.updateAllIn();
  }

  bool getAllInSetting() {
    return profileNotifier.allIn;
  }
}
