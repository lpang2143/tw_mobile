import 'package:flutter/material.dart';

class TwBackButton extends StatelessWidget {
  const TwBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        color: Colors.black,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
