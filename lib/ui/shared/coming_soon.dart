import 'package:flutter/material.dart';
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                // alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.black,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            const Text(
              'Coming soon...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
