import 'package:flutter/material.dart';

class TwLogo extends StatelessWidget {
  final double height;
  final double width;

  const TwLogo({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: const AssetImage('lib/assets/tw_logo.png'),
      height: height,
      width: width,
    );
  }
}
