import 'package:flutter/material.dart';
import 'package:tw_mobile/ui/pages/login_page/login_page.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/shared/login_options_row.dart';
import 'package:tw_mobile/ui/shared/tw_logo.dart';
import 'package:tw_mobile/ui/shared/login_divider.dart';
import 'package:tw_mobile/ui/shared/tw_back_button.dart';
import 'package:tw_mobile/ui/pages/reset_password_page/reset_password_page.dart';
import 'package:tw_mobile/ui/pages/registration_page/registration_page_controller.dart';
import 'package:tw_mobile/ui/theme/themes.dart';
import 'package:tw_mobile/data/status.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final RegistrationPageController stateManager = RegistrationPageController();
  Widget validWidget = const SizedBox();
  final emailController = TextEditingController();
  String email = '';
  final passwordController = TextEditingController();
  String password = '';
  final confirmPasswordController = TextEditingController();
  String confirmPassword = '';
  StringBuffer passwordErrorMessage = StringBuffer();
  bool keepEmail = true;
  bool faceId = false;
  bool noError = true;

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
        // reset confirm password text field if password field is changed
        confirmPasswordController.text = "";

        noError = true;
        passwordErrorMessage.clear();
        passwordErrorMessage.write("Password must contain: ");
        password = passwordController.text;

        stateManager.checkPassword(password);
        handlePasswordErrorMessage();
      });
    });
    confirmPasswordController.addListener(() {
      setState(() {
        confirmPassword = confirmPasswordController.text;
        stateManager.checkPasswordMatch(password, confirmPassword);
      });
    });
  }

  void _register() async {
    ApiClient apiClient = ApiClient();
    var attempt = await apiClient.registerUser(email, 'joe', 'test',
      '1', password);
    print('$attempt');
    if (attempt == Status.success) {
      if (!mounted) return;
      while (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(onLogin: () {
                    setState(() {});
                  })));
    } else if (attempt == Status.duplicateKey) {
      validWidget = const Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Text(
          "This email is already associated with a Ticket Wallet account",
          style: TextStyle(color: Color.fromRGBO(244, 67, 54, 0.5,)),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      validWidget = const Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Text(
          "Connection Error. Please try again.",
          style: TextStyle(color: Color.fromRGBO(244, 67, 54, 0.5)),
        ),
      );
    }
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
            child: ListView(children: [
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    _buildLogoBox(),
                    _buildRegisterText(),
                    const SizedBox(
                      height: 15,
                    ),
                    const LoginOptionsRow(),
                    const SizedBox(height: 50, child: LoginDivider()),
                    validWidget,
                    ListenableBuilder(
                      listenable: stateManager.emailNotifier,
                      builder: (BuildContext context, child) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(11)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: stateManager.getValidEmail()
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Colors.red,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                ),
                              ]),
                          child: TextField(
                            style: const TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                                hintText: 'EMAIL ADDRESS',
                                errorText: stateManager.getValidEmail()
                                    ? null
                                    : "Enter a valid email address",
                                hintStyle:
                                    Theme.of(context).textTheme.labelSmall,
                                border: InputBorder.none),
                            controller: emailController,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ListenableBuilder(
                      listenable: stateManager.passwordNotifier,
                      builder: (BuildContext context, child) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(11)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: noError
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Colors.red,
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
                              errorText: noError
                                  ? null
                                  : passwordErrorMessage.toString(),
                              border: InputBorder.none,
                            ),
                            controller: passwordController,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ListenableBuilder(
                        listenable: stateManager.passwordNotifier,
                        builder: (BuildContext context, child) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(11)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: stateManager.hasMatching()
                                        ? Theme.of(context).colorScheme.tertiary
                                        : Colors.red,
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                  )
                                ]),
                            child: TextField(
                              style: const TextStyle(fontSize: 20),
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'CONFIRM PASSWORD',
                                hintStyle:
                                    Theme.of(context).textTheme.labelSmall,
                                border: InputBorder.none,
                                errorText: stateManager.hasMatching()
                                    ? null
                                    : "Passwords must match",
                              ),
                              controller: confirmPasswordController,
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildLoginSwitches(),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildRegisterButton(),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildResetPasswordButton(),
                  ])))
        ])));
  }

  Widget _buildLogoBox() {
    return Container(
        alignment: Alignment.topCenter,
        height: 80,
        child: const TwLogo(height: 60, width: 60));
  }

  Widget _buildRegisterText() {
    return Column(
      children: [
        Text(
          'Create Account',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 30,
              ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text('Please Enter your details to create a Ticket Wallet account',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: const Color(0xFF807D7D),
                )),
      ],
    );
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
                    .labelSmall!
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
                  print('Keep Email switched to $keepEmail');
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
                    .labelSmall!
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
                  print('New FaceId value is $faceId');
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => const ResetPasswordPage())));
        },
        child: Text('Forgot your password?',
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: const Color(0xFF807D7D))),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Row(
      children: [
        Expanded(
          child: ListenableBuilder(
              listenable: stateManager.passwordNotifier,
              builder: (BuildContext context, child) {
                if (stateManager.hasMatching() &&
                    noError &&
                    stateManager.getValidEmail()) {
                  return ElevatedButton(
                    onPressed: () {
                      _register();
                      debugPrint('Create Account attempted');
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
                      'Create',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 21, color: Colors.white),
                    ),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.fromLTRB(0, 15, 0, 15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      )),
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.surface),
                    ),
                    child: Text(
                      'Create',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(fontSize: 21, color: Colors.white),
                    ),
                  );
                }
              }),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handlePasswordErrorMessage() {
    if (!stateManager.hasSpecialChar()) {
      noError = false;
      passwordErrorMessage
          .write('\n A special character from ! @ # \$ % ^ & *');
    }
    if (!stateManager.hasUpperCase()) {
      noError = false;
      passwordErrorMessage.write('\n An uppercase letter');
    }
    if (!stateManager.hasLowerCase()) {
      noError = false;
      passwordErrorMessage.write('\n A lowercase letter');
    }
    if (!stateManager.hasDigits()) {
      noError = false;
      passwordErrorMessage.write('\n A digit');
    }
    if (!stateManager.hasRequiredLength()) {
      noError = false;
      passwordErrorMessage
          .write('\n Atleast ${stateManager.getRequiredLength()} characters');
    }
  }
}
