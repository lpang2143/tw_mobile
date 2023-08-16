import 'package:flutter/material.dart';
import 'package:tw_mobile/data/help_page_data.dart';
import 'package:tw_mobile/ui/shared/help_page_widget.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: HelpPageWidget(subtitles: subtitles),
      ),
    );
  }
}

class HelpSubtitle {
  final String title;
  final List<String> messages;

  HelpSubtitle({
    required this.title,
    required this.messages,
  });
}
