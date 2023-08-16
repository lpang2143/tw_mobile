import 'package:flutter/material.dart';
import 'package:tw_mobile/ui/pages/help_page.dart';

class HelpPageWidget extends StatelessWidget {
  final List<HelpSubtitle> subtitles;

  const HelpPageWidget({required this.subtitles});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildHelpTitle(),
        Column(
          children: subtitles.map((subtitle) {
            return _buildHelpSubtitle(subtitle.title, subtitle.messages);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHelpSubtitle(String subtitle, List<String> messages) {
    return Builder(builder: (context) {
      return Column(
        children: [
          _buildSubtitleTitle(subtitle),
          Column(
            children: messages.map((message) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildHelpButton(context, message),
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Widget _buildSubtitleTitle(String subtitle) {
    return Builder(builder: (context) {
      return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
        child: Text(
          subtitle,
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontSize: 30.0),
        ),
      );
    });
  }

  Widget _buildHelpButton(BuildContext context, String message) {
    return SizedBox(
      width: 350.0,
      height: 50.0,
      child: GestureDetector(
        onTap: () {
          _handleButtonTap(context, message);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 14),
                ),
              ),
              _buildHelpButtonIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpButtonIcon() {
    return Container(
      width: 30.0,
      height: 30.0,
      decoration: const BoxDecoration(
        color: Color(0xFF625BF6),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
    );
  }

  void _handleButtonTap(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _helpPopupBox(message, context);
      },
    );
    debugPrint('Button tapped: $message');
  }

  AlertDialog _helpPopupBox(String message, BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 500.0,
        height: 500.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(height: 50.0),
            Text(
              // This will later be a configurable data variable
              'Answer: Answer to the question goes here.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildHelpTitle() {
    return Builder(builder: (context) {
      return Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 75.0, bottom: 10.0),
        child: Text(
          'Help',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 50.0,
              ),
        ),
      );
    });
  }
}
