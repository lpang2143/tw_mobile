import 'package:flutter/material.dart';
import 'package:tw_mobile/services/service_locator.dart';
import 'package:tw_mobile/ui/shared/bottom_nav_bar.dart';
import 'package:tw_mobile/ui/theme/themes.dart';
import 'package:tw_mobile/ui/shared/globals.dart';

void main() {
  getItSetup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicketWalletMobile',
      theme: defaultTheme,
      home: const MyHomePage(),
      navigatorObservers: [routeObserver],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
