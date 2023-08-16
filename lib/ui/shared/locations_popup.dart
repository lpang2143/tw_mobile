import 'package:flutter/material.dart';
import 'package:tw_mobile/data/city_data.dart';

class LocationsPopup extends StatelessWidget {
  final String selectedCity;
  final void Function(String city) updateSelectedCity;

  LocationsPopup({
    required this.selectedCity,
    required this.updateSelectedCity,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        _showLocationPicker(context);
      },
      child: Hero(
        tag: heroTag,
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              onPressed: null,
              label: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width / 3,
                ),
                child: FittedBox(
                  child: Text(
                    selectedCity,
                    style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              icon: const Icon(Icons.expand_more_sharp),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLocationPicker(BuildContext context) {
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) {
          return LocationPicker(
            cities: cities,
            updateSelectedCity: updateSelectedCity,
            selectedCity: selectedCity,
          );
        },
      ),
    );
  }
}

class LocationPicker extends StatelessWidget {
  final List<String> cities;
  final void Function(String city) updateSelectedCity;
  // Come back to this. Reference a new variable later
  // on so that this one can be made final
  String selectedCity;

  LocationPicker({
    required this.cities,
    required this.updateSelectedCity,
    required this.selectedCity,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Hero(
        tag: heroTag,
        child: Material(
          color: Colors.white,
          elevation: 2,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: height / 2,
            ),
            child: Column(
              children: [
                _buildHeader(),
                _buildCurrentLocationButton(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildCityButtons(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 10, 17, 88),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Align(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Pick A City",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentLocationButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ElevatedButton(
        onPressed: () {
          debugPrint("Current Location Pressed!");
          selectedCity = "Current Location";
          updateSelectedCity(selectedCity);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: const Color.fromRGBO(10, 17, 88, 1),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: FittedBox(
            child: Text(
              "USE CURRENT LOCATION",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color.fromRGBO(107, 149, 255, 1),
      height: 10,
      endIndent: 18,
      indent: 18,
    );
  }

  Widget _buildCityButtons() {
    return Column(
      children: cities
          .map(
            (data) => Column(
              children: [
                _buildDivider(),
                CityButton(
                  name: data,
                  updateSelectedCity: updateSelectedCity,
                  selectedCity: selectedCity,
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}

class CityButton extends StatelessWidget {
  final String name;
  final void Function(String city) updateSelectedCity;
  String selectedCity;

  CityButton({
    required this.name,
    required this.updateSelectedCity,
    required this.selectedCity,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          debugPrint("$name Pressed!");
          selectedCity = name;
          updateSelectedCity(selectedCity);
          Navigator.pop(context);
        },
        child: Text(
          name,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: const Color.fromRGBO(10, 17, 88, 1)),
        ),
      ),
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black38;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

const String heroTag = 'hero-tag';
