import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/user.dart';
import 'package:tw_mobile/services/api_client.dart';
// import 'package:tw_mobile/data/profile_page_options.dart';
import 'package:tw_mobile/ui/pages/edit_profile_page/edit_profile_page.dart';
import 'package:tw_mobile/ui/pages/login_page/login_page.dart';
import 'package:tw_mobile/ui/pages/profile_page/not_logged_in_button_pages.dart';
import 'package:tw_mobile/ui/pages/profile_page/profile_page_controller.dart';
import 'package:tw_mobile/ui/shared/globals.dart';

typedef OptionCallback = void Function();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  final ProfilePageController stateManager = ProfilePageController();
  final ScrollController _scrollController = ScrollController();
  double _profileX = 0;
  double _profileRad = 100;
  double _textScale = 1.0;
  double _nameX = 0;
  final double _nameY = 0;
  CrossAxisAlignment _textAlign = CrossAxisAlignment.center;
  bool notificationsToggled = true;
  bool allInToggled = true;
  final apiClient = ApiClient();
  Future<List<User>> user = Future(() => []);
  Future<bool> futureLoggedIn = Future(() => false);

  @override
  void initState() {
    super.initState();
    _initializeSession();
    _scrollController.addListener(() {
      _setProfilePictureSize();
      _setProfileAlignment();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _initializeSession();
  }

  void _initializeSession() async {
    try {
      bool logged = await _checkLoggedIn();
      if (logged) {
        _setUserData();
      }
    } catch (NoSessionFoundException) {
      debugPrint('No previous session found.');
    } finally {
      setState(() {
        futureLoggedIn = _checkLoggedIn();
      });
    }
    _profileX = 0;
    _profileRad = 100;
    _textScale = 1.0;
    _nameX = 0;
    _textAlign = CrossAxisAlignment.center;
  }

  Future<bool> _checkLoggedIn() async {
    return await apiClient.isLoggedIn();
  }

  void _setUserData() async {
    try {
      var user = fetchUserInfo();
      setState(() {
        this.user = user;
      });
    } catch (e) {
      // handle error
    }
  }

  Future<List<User>> fetchUserInfo() async {
    return await apiClient.getUserInfo();
  }

  void _changeProfilePos(double x) {
    setState(() {
      _profileX = x;
    });
  }

  void _changeNamePos(double x, CrossAxisAlignment alignment) {
    setState(() {
      _nameX = x;
      _textAlign = alignment;
    });
  }

  void _changeRad(double rad) {
    setState(() {
      _profileRad = rad;
    });
  }

  void _changeScale(double scale) {
    setState(() {
      _textScale = scale;
    });
  }

  void _updateNotifications() {
    setState(() {
      notificationsToggled = !notificationsToggled;
    });
  }

  void _updateAllIn() {
    setState(() {
      allInToggled = !allInToggled;
    });
  }

  void _setProfilePictureSize() {
    double offset = _scrollController.offset;
    double newRadius;
    double newScale;

    double newRadiusScale = (100 - offset) / 100;

    if (offset <= 0) {
      newRadius = 100;
      newScale = 1;
    } else {
      newRadius = max(50, 100 - offset);
      newScale = max(0.75, newRadiusScale);
    }

    _changeRad(newRadius);
    _changeScale(newScale);
  }

  void _setProfileAlignment() {
    double offset = _scrollController.offset;
    double newX;
    double newNameX;
    CrossAxisAlignment newAlignment;

    if (offset <= 0) {
      newX = 0;
      newNameX = 0;
      newAlignment = CrossAxisAlignment.center;
    } else {
      double norm = (100 - offset) / 100;
      newX = max(norm - 1, -0.95);
      newNameX = max(norm - 0.9, -0.30);
      newAlignment = CrossAxisAlignment.start;
    }

    _changeProfilePos(newX);
    _changeNamePos(newNameX, newAlignment);
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets mediaPadding = MediaQuery.of(context).padding;

    return FutureBuilder(
      future: futureLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return _createLoggedInProfile(context, mediaPadding);
          } else {
            return _createNotLoggedInProfile(context, mediaPadding);
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Scaffold _createNotLoggedInProfile(
      BuildContext context, EdgeInsets mediaPadding) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 140,
              collapsedHeight: 70,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                centerTitle: true,
                title: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      alignment: Alignment(_profileX, 0),
                      child: ProfilePicture(radius: _profileRad * 1),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Center(
                child: _buildRoundedContainer(
                  text: 'Login',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          onLogin: () {
                            setState(() {
                              _initializeSession();
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: mediaPadding.left + 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildSubtitle(subtitle: 'My Wallet'),
                    const SizedBox(height: 15),
                    OptionsBox(
                        options: stateManager.profileNotifier.myWallet,
                        loggedIn: false),
                    const SizedBox(height: 15),
                    _buildSubtitle(subtitle: 'Preferences'),
                    const SizedBox(height: 15),
                    OptionsBox(
                        options: stateManager.profileNotifier.preferencesOff,
                        loggedIn: false),
                    const SizedBox(height: 15),
                    _buildSubtitle(subtitle: 'Notifications'),
                    const SizedBox(height: 15),
                    OptionsBox(
                        options: stateManager
                            .profileNotifier.notificationsOffOptions,
                        loggedIn: false),
                    const SizedBox(height: 15),
                    _buildSubtitle(subtitle: 'Payment Options'),
                    const SizedBox(height: 15),
                    OptionsBox(
                        options: stateManager.profileNotifier.payment,
                        loggedIn: false),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ])),
          ],
        ),
      ),
    );
  }

  Scaffold _createLoggedInProfile(
      BuildContext context, EdgeInsets mediaPadding) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 265,
              collapsedHeight: 70,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.4,
                centerTitle: true,
                title: Stack(
                  children: [
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        alignment: Alignment(_profileX, 0),
                        child: ProfilePicture(radius: _profileRad)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      alignment: Alignment(_nameX, _nameY),
                      child: FutureBuilder(
                        future: user,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data != null) {
                              return ProfileText(
                                name:
                                    '${snapshot.data![0].firstName} ${snapshot.data![0].lastName}',
                                email: snapshot.data![0].email,
                                scale: _textScale,
                                alignment: _textAlign,
                              );
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              const SizedBox(height: 10), // to push down the list
              Center(
                child: _buildRoundedContainer(
                  text: 'Edit Profile',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: mediaPadding.left + 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildSubtitle(subtitle: 'My Wallet'),
                    const SizedBox(height: 15),
                    OptionsBox(
                        options: stateManager.profileNotifier.myWallet,
                        loggedIn: true),
                    const SizedBox(height: 15),
                    _buildSubtitle(subtitle: 'Preferences'),
                    const SizedBox(height: 15),
                    ListenableBuilder(
                      listenable: stateManager.profileNotifier,
                      builder: (BuildContext context, child) {
                        if (stateManager.getAllInSetting()) {
                          return OptionsBox(
                              options:
                                  stateManager.profileNotifier.preferencesOn,
                              loggedIn: true);
                        } else {
                          return OptionsBox(
                              options:
                                  stateManager.profileNotifier.preferencesOff,
                              loggedIn: true);
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildSubtitle(subtitle: 'Notifications'),
                    const SizedBox(height: 15),
                    ListenableBuilder(
                      listenable: stateManager.profileNotifier,
                      builder: (BuildContext context, child) {
                        if (stateManager.getNotificationSetting()) {
                          return OptionsBox(
                              options: stateManager
                                  .profileNotifier.notificationsOnOptions,
                              loggedIn: true);
                        } else {
                          return OptionsBox(
                              options: stateManager
                                  .profileNotifier.notificationsOffOptions,
                              loggedIn: true);
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildSubtitle(subtitle: 'Payment Options'),
                    const SizedBox(height: 15),
                    OptionsBox(
                        options: stateManager.profileNotifier.payment,
                        loggedIn: true),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ])),
          ],
        ),
      ),
    );
  }

  Container _buildSubtitle({required String subtitle}) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        subtitle,
        style: const TextStyle(fontSize: 16, color: Color(0xFF0A1158)),
      ),
    );
  }

  Container _buildRoundedContainer({
    required String text,
    required VoidCallback onTap,
  }) {
    final borderRadius = BorderRadius.circular(20);
    final boxShadow = [
      BoxShadow(
        color: Color(0xffD7D6FF),
        blurRadius: 0,
        spreadRadius: 1,
      ),
    ];

    return Container(
      width: 250,
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(134, 64, 249, 0.7),
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionsBox extends StatelessWidget {
  final List<Option> options;
  final bool loggedIn;

  OptionsBox({required this.options, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: double.infinity,
        height: options.length * 50.0,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: [
            BoxShadow(
              color: const Color.fromRGBO(134, 64, 249, 0.7),
              blurRadius: 2,
              offset: const Offset(0, 0),
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          children: options.asMap().entries.map((entry) {
            final index = entry.key;
            Option option = entry.value;
            Function() onTapOption = entry.value.onTap;
            final isLastItem = index == options.length - 1;
            if (!loggedIn) {
              onTapOption = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotLoggedInButtonPages(
                        text: option.text, image: option.image),
                  ),
                );
              };
              if (option.label == 'On/Off' || option.label == 'All-in Prices') {
                onTapOption = () => null;
              }
            }
            return Expanded(
              child: GestureDetector(
                onTap: onTapOption,
                child: Container(
                  decoration: BoxDecoration(
                    border: isLastItem
                        ? null
                        : Border(
                            bottom: BorderSide(
                            color: Color.fromRGBO(134, 64, 249, 0.7),
                          )),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          option.label,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.surface),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          option.icon,
                          color: option.color,
                          size: option.size,
                          shadows: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.secondary,
                              blurRadius: 0.2,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Option {
  final String label;
  final OptionCallback onTap;
  final IconData icon;
  final double size;
  final Color color;
  final String text;
  final String image;

  Option({
    required this.label,
    required this.onTap,
    required this.icon,
    required this.size,
    required this.color,
    required this.text,
    required this.image,
  });
}

class ProfilePicture extends StatelessWidget {
  // TODO: Add image functionality
  double radius;
  ProfilePicture({required this.radius});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Profile Pic',
      child: Container(
        width: radius,
        height: radius,
        decoration: const ShapeDecoration(
            shape: OvalBorder(),
            color: Colors.grey,
            shadows: [
              BoxShadow(color: Color.fromRGBO(134, 64, 249, 0.7), blurRadius: 2)
            ]),
      ),
    );
  }
}

class ProfileText extends StatelessWidget {
  String name;
  String email;
  double scale;
  CrossAxisAlignment alignment;

  ProfileText({
    required this.name,
    required this.email,
    this.scale = 1.0,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: 250,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: alignment,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 30 * scale,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              email,
              style: TextStyle(
                fontSize: 16 * scale,
                color: const Color.fromRGBO(134, 64, 249, 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
