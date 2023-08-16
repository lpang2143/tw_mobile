import 'package:flutter/material.dart';
import 'package:tw_mobile/services/api_client.dart';

class UploadPage extends StatelessWidget {
  final Color containerColor = const Color(0xff6B95FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Stack(
                  children: [
                    Image.asset(
                      'lib/assets/title_banner.png',
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                    Positioned.fill(
                      left: 10,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color.fromRGBO(
                                      107, 149, 255, 0.7))),
                          child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 7),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Color.fromRGBO(10, 17, 88, 1),
                                ),
                              )),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                glowContainer(
                  text: 'Type in the Barcode',
                  onTap: () {
                    barcodePopup(context);
                  },
                ),
                const SizedBox(height: 40),
                glowContainer(
                  text: 'Scan PDF',
                  onTap: () {
                    debugPrint('Scan PDF tapped!');
                  },
                ),
                const SizedBox(height: 40),
                glowContainer(
                  text: 'Transfer from TicketMaster Account',
                  onTap: () {
                    debugPrint('Transfer from TicketMaster Account tapped!');
                  },
                ),
                const SizedBox(height: 40),
                glowContainer(
                  text: 'Add From Apple Wallet',
                  onTap: () {
                    debugPrint('Add From Apple Wallet tapped!');
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  width: 250,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Color(0xff6548EA),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'lib/assets/tw_logo.png',
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Divider(
                          thickness: 2,
                          color: Color(0xff6548EA),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget glowContainer({required String text, required Function onTap}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        width: 368,
        height: 90,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0xff6B95FF),
              blurRadius: 3,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0A1158),
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  void barcodePopup(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Type in the Barcode'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter Barcode',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                String barcode = controller.text;
                ApiClient().uploadBarcode(barcode);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
