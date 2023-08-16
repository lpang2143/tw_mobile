import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginCard extends StatelessWidget {
  final String type;

  const LoginCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // Default is apple icon
    Widget buttonChild = const Icon(Icons.apple);
    Color shadowColor;

    switch (type) {
      case 'apple':
        shadowColor = const Color(0xFF0A1158);
        break;
      case 'google':
        buttonChild = SvgPicture.asset(
          'lib/assets/google.svg',
          width: 20,
          height: 20,
        );
        shadowColor = const Color(0xFF23B299);
        break;
      case 'ticketmaster':
        buttonChild = SvgPicture.asset(
          'lib/assets/ticketmaster.svg',
          width: 20,
          height: 20,
        );
        shadowColor = const Color(0xFF6B95FF);
        break;
      default:
        throw ArgumentError(
            'argument must be apple, google or ticketmaster String');
    }

    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(11)),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.3),
                blurRadius: 2,
                spreadRadius: 2,
              )
            ],
            color: Colors.white),
        child: Center(
            child: GestureDetector(
          onTap: () {},
          child: buttonChild,
        )));
  }
}
