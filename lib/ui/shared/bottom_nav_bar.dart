import 'package:flutter/material.dart';
import 'package:tw_mobile/ui/pages/home_page/home_page.dart';
import 'package:tw_mobile/ui/pages/sell_page.dart';
import 'package:tw_mobile/ui/pages/profile_page/profile_page.dart';
import 'package:tw_mobile/ui/pages/tickets_page/tickets_page.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  BottomNavigationBarWidgetState createState() =>
      BottomNavigationBarWidgetState();
}

class BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _currentIndex = 0; // Track the selected tab index

  // Define the pages/screens that correspond to each tab
  final List<Widget> _pages = [
    HomePage(),
    MyTicketsPage(),
    const SellPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the current selected page/screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex, // Set the current selected tab
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Update the selected tab index
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: 'My Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange_outlined),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
