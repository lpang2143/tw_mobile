import 'package:flutter/material.dart';
import 'package:tw_mobile/ui/shared/login_card.dart';

class LoginOptionsRow extends StatelessWidget {
  const LoginOptionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 82) / 3;

    return Wrap(
      spacing: 15,
      direction: Axis.horizontal,
      children: [
        SizedBox(
            width: width, height: 50, child: const LoginCard(type: 'apple')),
        SizedBox(
            width: width, height: 50, child: const LoginCard(type: 'google')),
        SizedBox(
            width: width,
            height: 50,
            child: const LoginCard(type: 'ticketmaster')),
      ],
    );
  }
}
