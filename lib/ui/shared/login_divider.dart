import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    Color dividerColor = const Color(0xFFADADAD);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          color: dividerColor,
          width: MediaQuery.of(context).size.width / 3,
          height: 1,
        ),
        Text('OR',
            style: GoogleFonts.getFont('Domine')
                .copyWith(fontSize: 15, color: dividerColor)),
        Container(
          color: dividerColor,
          width: MediaQuery.of(context).size.width / 3,
          height: 1,
        ),
      ],
    );
  }
}
