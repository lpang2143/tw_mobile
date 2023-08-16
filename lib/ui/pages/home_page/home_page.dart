import 'package:flutter/material.dart';
import 'package:tw_mobile/data/ticket_data.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/data/classes/event.dart';
import 'package:tw_mobile/ui/pages/potd_page.dart';
import 'package:tw_mobile/ui/pages/registration_page/registration_page.dart';
import 'package:tw_mobile/ui/shared/coming_soon.dart';
import 'package:tw_mobile/ui/shared/locations_popup.dart';
import 'package:tw_mobile/ui/shared/sports_icon.dart';
import 'package:tw_mobile/data/sports_data.dart';
import 'package:tw_mobile/ui/pages/login_page/login_page.dart';
import 'package:tw_mobile/ui/shared/event_widget.dart';
import 'package:tw_mobile/ui/pages/home_page/search_function.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final SessionManager _sessionManager = SessionManager();
  String selectedSport = 'NBA';
  String selectedCity = 'Miami';
  Future<bool> loggedIn = Future(() => false);

  List<Event> eventList = [];

  final apiClient =
      ApiClient(); // Replace with your actual API client instantiation in prod

  @override
  void initState() {
    super.initState();
    _fetchEventList();
    _initializeSession();
    loggedIn = _checkLoggedIn();
  }

  void _initializeSession() async {
    try {
      bool remembered = await _sessionManager.getSession('autoLogin') == 'true';
      bool logged = await _checkLoggedIn();
      if (remembered) {
        await apiClient.autoLogin();
      } else if (logged && !remembered) {
        await apiClient.logout();
      }
    } catch (NoSessionFoundException) {
      debugPrint('No previous session found.');
    } finally {
      setState(() {
        loggedIn = _checkLoggedIn();
      });
    }
  }

  Future<bool> _checkLoggedIn() async {
    return await apiClient.isLoggedIn();
  }

  void _logout() async {
    var attempt = await apiClient.logout();
    debugPrint('Successful: $attempt');
    if (attempt) {
      if (!mounted) return;
      setState(() {
        loggedIn = _checkLoggedIn();
      });
    }
  }

  void _fetchEventList() async {
    try {
      var events = await apiClient.getTrendingEvents();
      setState(() {
        eventList = events;
      });
    } catch (e) {
      // handle exception
    }
  }

  void updateSelectedSport(String sport) {
    setState(() {
      selectedSport = sport;
    });
  }

  void updateSelectedCity(String city) {
    setState(() {
      selectedCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets mediaPadding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(top: mediaPadding.top),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LocationsPopup(
                  selectedCity: selectedCity,
                  updateSelectedCity: updateSelectedCity,
                ),
                FutureBuilder(
                  future: loggedIn,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data == true) {
                        return _buildProfileButton(
                          onTap: _logout,
                        );
                      } else {
                        return _topButtonRow(context: context);
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SearchTextField(),
            ),
            const SizedBox(height: 20),
            ButtonSection(),
            const SizedBox(height: 15),
            TrendingNowText(),
            const SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SportsIcons(
                sportsData: sportsData,
                updateFunction: updateSelectedSport,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: EventWidget(
                eventList: eventList,
                filter: selectedSport,
                eventType: EventType.unowned,
              ),
            ),
            const SizedBox(height: 12),
            UpcomingText(),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: EventWidget(
                eventList: eventList,
                filter: selectedSport,
                eventType: EventType.unowned,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.account_circle_outlined,
          color: Theme.of(context).colorScheme.tertiary,
          size: 45,
        ),
      ),
    );
  }

  Widget _topButtonRow({required BuildContext context}) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LoginPage(
                  onLogin: () {
                    setState(() {
                      loggedIn = _checkLoggedIn();
                    });
                  },
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const RegistrationPage())));
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            'Join',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        // TODO: Add logo
      ],
    );
  }
}

class TrendingNowText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        'Trending Now',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class UpcomingText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(
        'Upcoming',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => ComingSoonPage())));
          },
          image: 'lib/assets/priceTag.png',
          label: 'Promos',
        ),
        _buildButton(
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: ((context) => PickOfTheDayPage(
            //           // TODO: Implement the trending tickets so this works properly
            //           pickTicket: null,
            //           odds: -1.5,
            //           lowestPrice: 50.0,
            //         )),
            //   ),
            // );
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => ComingSoonPage())));
          },
          image: 'lib/assets/lockPOTD.png',
          label: 'POTD',
        ),
        _buildButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => ComingSoonPage())));
          },
          image: 'lib/assets/coins.png',
          label: 'Earn \$',
        ),
      ],
    );
  }

// make stateles widget
  Widget _buildButton({
    required VoidCallback onPressed,
    required String image,
    required String label,
  }) {
    return Builder(builder: (context) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(10, 17, 88, 0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: Image.asset(
                  image,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      );
    });
  }
}
