import 'package:flutter/material.dart';
import 'package:tw_mobile/ui/pages/login_page/login_page.dart';
import 'package:tw_mobile/ui/pages/registration_page/registration_page.dart';

class NotLoggedInButtonPages extends StatelessWidget {
  final String text;
  final String image;
  const NotLoggedInButtonPages(
      {super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  color: Colors.black,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            SizedBox(height: height / 8),
            Column(
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 30),
                Image.asset(image),
                const SizedBox(height: 30),
                const Text(
                  'Sign up or log in to view',
                  style: TextStyle(color: Color.fromRGBO(10, 17, 88, 0.47)),
                ),
              ],
            ),
            SizedBox(height: height / 7),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => const RegistrationPage())));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Sign up',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => LoginPage(
                                  onLogin: () => null,
                                ))));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.5),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Terms of Use | Privacy Policy',
                  style: TextStyle(color: Color.fromRGBO(10, 17, 88, 0.47)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
