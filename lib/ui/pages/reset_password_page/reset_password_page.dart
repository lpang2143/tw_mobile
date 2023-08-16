import 'package:flutter/material.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/pages/reset_password_page/reset_password_page_controller.dart';
import 'package:tw_mobile/ui/shared/tw_logo.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final stateManager = ResetPasswordPageController();
  final emailController = TextEditingController();
  String email = '';
  ApiClient apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        email = emailController.text;
        stateManager.checkEmail(email);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Align(alignment: Alignment.topLeft, child: BackButton()),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        alignment: Alignment.topCenter,
                        height: 90,
                        child: const TwLogo(height: 60, width: 60)),
                    _buildResetPasswordHeader(),
                    const SizedBox(
                      height: 15,
                    ),
                    ListenableBuilder(
                      listenable: stateManager,
                      builder: (BuildContext context, child) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(11)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: stateManager.validEmail
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
                                errorText: stateManager.validEmail
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
                      height: 25,
                    ),
                    _buildResetPasswordButton(),
                    const BackToLoginButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetPasswordHeader() {
    return Column(
      children: [
        Text(
          'Reset Password',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 30,
              ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text('Please enter your email address to reset your password',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: const Color(0xFF807D7D))),
      ],
    );
  }

  Widget _buildResetPasswordButton() {
    if (stateManager.validEmail) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                apiClient.resetPassword(email);
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
                'Reset',
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
                backgroundColor:
                    const MaterialStatePropertyAll<Color>(Colors.red),
              ),
              child: Text(
                'Reset',
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
}

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

class BackToLoginButton extends StatelessWidget {
  const BackToLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text('Back to Login',
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: const Color(0xFF807D7D))),
      ),
    );
  }
}
