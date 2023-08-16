import 'package:flutter/material.dart';
import 'package:tw_mobile/ui/pages/profile_page/profile_page.dart';

class ProfilePageNotifier with ChangeNotifier {
  bool _notifications = true;
  bool get notifications => _notifications;
  bool _allIn = true;
  bool get allIn => _allIn;
  // secondary color but hard coded because i'm not sure how to access context
  final Color _secondaryColor = const Color.fromRGBO(134, 64, 249, 0.7);
  final Color _offColor = Colors.grey;

  void updateNotifications() {
    _notifications = !_notifications;
    notifyListeners();
  }

  void updateAllIn() {
    _allIn = !_allIn;
    notifyListeners();
  }

  late List<Option> myWallet = [
    Option(
        label: 'Referral',
        onTap: () {
          debugPrint('Referral tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Refer a Friend',
        image: 'lib/assets/referAFriend.png'),
    Option(
        label: 'Wallet Value',
        onTap: () {
          debugPrint('Wallet Value tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Wallet Value',
        image: 'lib/assets/walletValue.png'),
    Option(
        label: 'Price Floor',
        onTap: () {
          debugPrint('Price Floor tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Price Floor',
        image: 'lib/assets/priceFloor.png'),
  ];

  late List<Option> preferencesOn = [
    Option(
        label: 'Favorites',
        onTap: () {
          debugPrint('Favorites tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Favorites',
        image: 'lib/assets/favorites.png'),
    Option(
        label: 'Location',
        onTap: () {
          debugPrint('Location tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Location',
        image: 'lib/assets/location.png'),
    Option(
        label: 'All-in Prices',
        onTap: () {
          updateAllIn();
          debugPrint("All-in is now $_allIn");
        },
        icon: Icons.toggle_on,
        size: 50,
        color: _secondaryColor,
        text: '',
        image: ''),
  ];

  late List<Option> preferencesOff = [
    Option(
        label: 'Favorites',
        onTap: () {
          debugPrint('Favorites tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Favorites',
        image: 'lib/assets/favorites.png'),
    Option(
        label: 'Location',
        onTap: () {
          debugPrint('Location tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Location',
        image: 'lib/assets/location.png'),
    Option(
        label: 'All-in Prices',
        onTap: () {
          updateAllIn();
          debugPrint("All-in is now $_allIn");
        },
        icon: Icons.toggle_off,
        size: 50,
        color: _offColor,
        text: '',
        image: ''),
  ];

  late List<Option> notificationsOnOptions = [
    Option(
        label: 'Recent',
        onTap: () {
          debugPrint('Recent tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Notifications',
        image: 'lib/assets/notifications.png'),
    Option(
        label: 'Customize',
        onTap: () {
          debugPrint('Customize tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Customize',
        image: 'lib/assets/customize.png'),
    Option(
        label: 'On/Off',
        onTap: () {
          updateNotifications();
          debugPrint("notifications are now $_notifications");
        },
        icon: Icons.toggle_on,
        size: 50,
        color: _secondaryColor,
        text: '',
        image: ''),
  ];

  late List<Option> notificationsOffOptions = [
    Option(
        label: 'Recent',
        onTap: () {
          debugPrint('Recent tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Notifications',
        image: 'lib/assets/notifications.png'),
    Option(
        label: 'Customize',
        onTap: () {
          debugPrint('Customize tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Customize',
        image: 'lib/assets/customize.png'),
    Option(
        label: 'On/Off',
        onTap: () {
          updateNotifications();
          debugPrint("notifications are now $_notifications");
        },
        icon: Icons.toggle_off,
        size: 50,
        color: _offColor,
        text: '',
        image: ''),
  ];

  late List<Option> payment = [
    Option(
        label: 'Saved',
        onTap: () {
          debugPrint('Saved tapped');
        },
        icon: Icons.arrow_forward_ios_rounded,
        size: 24,
        color: _secondaryColor,
        text: 'Payment Methods',
        image: 'lib/assets/paymentMethods.png'),
    Option(
        label: 'Add Credit/Debit Card',
        onTap: () {
          debugPrint('Add Credit/Debit Card tapped');
        },
        icon: Icons.add_circle_outline,
        size: 30,
        color: _secondaryColor,
        text: '',
        image: ''),
  ];
}
