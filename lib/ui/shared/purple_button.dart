import 'package:flutter/material.dart';

class PurpleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String buttonText;
  final Color lightPurple = const Color(0xFF625BF6);

  const PurpleButton({Key? key, this.onTap, required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 325,
        height: 70,
        decoration: BoxDecoration(
          color: lightPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 20,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
