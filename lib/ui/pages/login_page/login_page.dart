import 'package:flutter/material.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/pages/login_page/login_page_controller.dart';
import 'package:tw_mobile/ui/pages/registration_page/registration_page.dart';
import 'package:tw_mobile/ui/shared/tw_back_button.dart';
import 'package:tw_mobile/ui/shared/tw_logo.dart';
import 'package:tw_mobile/ui/shared/login_divider.dart';
import 'package:tw_mobile/ui/shared/login_options_row.dart';
import 'package:tw_mobile/ui/pages/reset_password_page/reset_password_page.dart';
import 'package:tw_mobile/services/service_locator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({required this.onLogin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SessionManager _sessionManager = SessionManager();
  ApiClient apiClient = ApiClient();
  Widget validWidget = const SizedBox();
  bool success = false;
  final stateManager = LoginPageController();
  final emailController = TextEditingController();
  String email = '';
  final passwordController = TextEditingController();
  String password = '';
  bool keepEmail = true;
  bool faceId = false;
  bool valid = true;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        email = emailController.text;
        stateManager.checkEmail(email);
      });
    });
    passwordController.addListener(() {
      setState(() {
        password = passwordController.text;
        stateManager.checkPassword(password);
      });
    });
  }

  void _login() async {
    var attempt = await apiClient.login(email, password);
    if (attempt) {
      if (!mounted) return;
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _sessionManager.storeSession('autoLogin', keepEmail.toString());
      widget.onLogin();
    } else {
      validWidget = const Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Text(
          "Email or Password were not correct",
          style: TextStyle(color: Color.fromRGBO(244, 67, 54, 0.5)),
        ),
      );
    }
  }

  void updateValid() {
    setState(() {
      if (stateManager.hasValidEmail() &&
          stateManager.hasValidPassword() &&
          password.isNotEmpty) {
        valid = true;
      } else {
        valid = false;
        validWidget = validWidget = const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            "Email or Password were not valid",
            style: TextStyle(color: Color.fromRGBO(244, 67, 54, 0.5)),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const TwBackButton(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: SafeArea(
            child: ListView(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  _buildLogoBox(),
                  _buildLoginText(),
                  const SizedBox(
                    height: 15,
                  ),
                  const LoginOptionsRow(),
                  const SizedBox(height: 50, child: LoginDivider()),
                  validWidget,
                  ListenableBuilder(
                    listenable: stateManager.loginNotifier,
                    builder: (BuildContext context, child) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(11)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: stateManager.hasValidEmail()
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Colors.red,
                              spreadRadius: 1,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: TextField(
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              hintText: 'EMAIL ADDRESS',
                              errorText: stateManager.hasValidEmail()
                                  ? null
                                  : "Enter a valid email address",
                              hintStyle: Theme.of(context).textTheme.labelSmall,
                              border: InputBorder.none),
                          controller: emailController,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  ListenableBuilder(
                    listenable: stateManager.loginNotifier,
                    builder: (BuildContext context, child) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(11)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.tertiary,
                                spreadRadius: 1,
                                blurRadius: 1,
                              )
                            ]),
                        child: TextField(
                          style: const TextStyle(fontSize: 20),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'PASSWORD',
                            hintStyle: Theme.of(context).textTheme.labelSmall,
                            border: InputBorder.none,
                          ),
                          controller: passwordController,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildLoginSwitches(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildLoginButton(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildResetPasswordButton(),
                  _buildRegisterRow(),
                ]),
              ),
            )
          ],
        )));
  }

  Widget _buildLogoBox() {
    return Container(
        alignment: Alignment.topCenter,
        height: 80,
        child: const TwLogo(height: 60, width: 60));
  }

  Widget _buildLoginButton() {
    if (stateManager.hasValidEmail()) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                updateValid();
                if (valid) {
                  _login();
                }
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.fromLTRB(0, 15, 0, 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                )),
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.primary),
              ),
              child: Text(
                'Log In',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontSize: 21, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: null,
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.fromLTRB(0, 15, 0, 15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                )),
                backgroundColor: const MaterialStatePropertyAll(Colors.red),
              ),
              child: Text(
                'Log In',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontSize: 21, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildLoginText() {
    return Column(children: [
      Text(
        'Login',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 30,
            ),
      ),
      const SizedBox(
        height: 15,
      ),
      Text('Please Enter your details to sign in',
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: const Color(0xFF807D7D))),
    ]);
  }

  Widget _buildLoginSwitches() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Remember my Email',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15)),
            SizedBox(
              height: 25,
              child: Switch(
                // Will add functionality later
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: keepEmail,
                activeColor: const Color(0xFF6B95FF),
                onChanged: (bool value) {
                  setState(() {
                    keepEmail = value;
                  });
                },
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Enable FaceID',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15)),
            SizedBox(
              height: 25,
              child: Switch(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: faceId,
                activeColor: const Color(0xFF6B95FF),
                onChanged: (bool value) {
                  setState(() {
                    faceId = value;
                  });
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildResetPasswordButton() {
    return SizedBox(
      height: 30,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => ResetPasswordPage())));
        },
        child: Text('Forgot your password?',
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: const Color(0xFF807D7D))),
      ),
    );
  }

  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: const Color(0xFF807D7D))),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrationPage()));
          },
          child: Text('Create an Account',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).colorScheme.secondary)),
        ),
      ],
    );
  }
}
