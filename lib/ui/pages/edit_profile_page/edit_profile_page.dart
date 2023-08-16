import 'package:flutter/material.dart';
import 'package:tw_mobile/data/classes/user.dart';
import 'package:tw_mobile/services/api_client.dart';
import 'package:tw_mobile/ui/pages/edit_profile_page/edit_profile_page_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final EditProfileController stateManager = EditProfileController();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dobController = TextEditingController();
  Future<List<User>> user = Future(() => []);
  final apiClient =
      ApiClient(); // Replace with your actual API client instantiation in prod

  @override
  void initState() {
    super.initState();
    _setUserData();
    // Future.delayed(Duration(seconds: 2), () {});

    // firstNameController.addListener(() {
    //   setState(() {
    //     stateManager.checkFirstName(firstNameController.text);
    //     debugPrint('${stateManager.validFirstName()}');
    //   });
    // });
  }

  void _setUserData() async {
    try {
      var user = fetchUserInfo();
      setState(() {
        this.user = user;
      });
    } catch (e) {
      // handle error
    }
  }

  Future<List<User>> fetchUserInfo() async {
    return await apiClient.getUserInfo();
  }

  Future<void> updateProfile() async {
    String email = emailController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String phoneNumber = phoneNumberController.text;
    String dob = dobController.text;
    debugPrint('$email $firstName $lastName $phoneNumber $dob');
    stateManager.checkValidUpdate(email, firstName, lastName, phoneNumber, dob);
    if (stateManager.validUpdate) {
      stateManager.updateProfile(email, firstName, lastName, phoneNumber, dob);
    } else {
      debugPrint('Invalid Update');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(134, 64, 249, 0.7),
          elevation: 0,
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              emailController.text = snapshot.data![0].email;
              firstNameController.text = snapshot.data![0].firstName;
              lastNameController.text = snapshot.data![0].lastName;
              phoneNumberController.text = snapshot.data![0].phoneNumber;
              dobController.text = snapshot.data![0].dob;
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const EditProfilePicture(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildChangePasswordButton(),
                  const SizedBox(height: 30),
                  _buildSubtitle(
                    subtitle: 'Email',
                  ),
                  // will query for current user settings when api online.
                  EditProfileRow(
                    noError: true,
                    isClickable: false,
                    controller: emailController,
                    errorMessage: '',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildSubtitle(subtitle: 'First Name'),
                  ListenableBuilder(
                    listenable: stateManager.firstNameNotifier,
                    builder: (BuildContext context, child) {
                      return EditProfileRow(
                        noError: stateManager.validFirstName(),
                        locked: false,
                        controller: firstNameController,
                        errorMessage: 'Enter a valid name',
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildSubtitle(subtitle: 'Last Name'),
                  ListenableBuilder(
                    listenable: stateManager.lastNameNotifier,
                    builder: (BuildContext context, child) {
                      return EditProfileRow(
                        noError: stateManager.validLastName(),
                        locked: false,
                        controller: lastNameController,
                        errorMessage: 'Enter a valid name',
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildSubtitle(subtitle: 'Phone Number'),
                  ListenableBuilder(
                    listenable: stateManager.lastNameNotifier,
                    builder: (BuildContext context, child) {
                      return EditProfileRow(
                        noError: stateManager.validNumber(),
                        locked: false,
                        controller: phoneNumberController,
                        errorMessage: 'Enter a valid phone number',
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildSubtitle(subtitle: 'DOB'),
                  ListenableBuilder(
                    listenable: stateManager.lastNameNotifier,
                    builder: (BuildContext context, child) {
                      return EditProfileRow(
                        noError: stateManager.validDate(),
                        locked: false,
                        controller: dobController,
                        errorMessage: 'DOB must be in the format of yyyy-mm-dd',
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  SaveButton(
                    updateFunction: updateProfile,
                    errors: stateManager.validFirstName() &&
                        stateManager.validLastName() &&
                        stateManager.validNumber() &&
                        stateManager.validDate(),
                  ),
                  const SizedBox(height: 30)
                ],
              );
            } else {
              return const SizedBox();
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class EditProfilePicture extends StatelessWidget {
  const EditProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    // need api to fetch profile pic
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: 'Profile Pic',
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // Placeholder so that the icon will show up.
                color: Color.fromARGB(255, 207, 207, 207),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(134, 64, 249, 0.7),
                    blurRadius: 2,
                  )
                ]),
          ),
        ),
        const Image(
          image: AssetImage('lib/assets/edit.png'),
          color: Color.fromRGBO(134, 64, 249, 0.5),
        ),
      ],
    );
  }
}

class SaveButton extends StatefulWidget {
  final Future<void> Function() updateFunction;
  final bool errors;
  SaveButton({super.key, required this.updateFunction, required this.errors});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await widget.updateFunction();
        // debugPrint('${widget.errors}');
        // if (!widget.errors) {
        //   if (mounted) {
        //     Navigator.of(context).pop();
        //   }
        // }
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          backgroundColor: const Color.fromRGBO(134, 64, 249, 0.7),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
              side: const BorderSide(
                color: Color.fromRGBO(134, 64, 249, 0.7),
              )),
          textStyle: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          )),
      child: Text(
        'SAVE',
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: 16, color: Colors.white),
      ),
    );
  }
}

Container _buildChangePasswordButton() {
  return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(134, 64, 249, 0.7),
              blurRadius: 0,
              spreadRadius: 1)
        ],
        borderRadius: BorderRadius.circular(45),
        color: const Color.fromRGBO(134, 64, 249, 0.7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 33,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(45)),
            child: const Text('***',
                style: TextStyle(color: Color(0xFF625BF6), fontSize: 30)),
          ),
          const SizedBox(
            width: 15,
          ),
          const Text(
            'CHANGE PASSWORD',
            style: TextStyle(fontSize: 16, color: Colors.white),
          )
        ],
      ));
}

Container _buildSubtitle({required String subtitle}) {
  return Container(
    padding: const EdgeInsets.only(bottom: 2),
    alignment: Alignment.centerLeft,
    child: Text(
      subtitle,
      style: const TextStyle(fontSize: 16, color: Color(0xFF0A1158)),
    ),
  );
}

class EditProfileRow extends StatefulWidget {
  final bool locked;
  final bool isClickable;
  final TextEditingController controller;
  final bool noError;
  final String errorMessage;

  const EditProfileRow({
    this.locked = true,
    this.isClickable = true,
    required this.controller,
    required this.noError,
    required this.errorMessage,
  });

  @override
  State<EditProfileRow> createState() => _EditProfileRowState();
}

class _EditProfileRowState extends State<EditProfileRow> {
  @override
  Widget build(BuildContext context) {
    String image = 'lib/assets/edit.png';
    if (widget.locked) {
      image = 'lib/assets/lock.png';
    }

    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(11)),
                color: widget.locked
                    ? const Color.fromARGB(255, 207, 207, 207)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: widget.noError
                        ? const Color.fromRGBO(134, 64, 249, 0.7)
                        : Colors.red,
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ]),
            child: TextField(
              enabled: !widget.locked,
              controller: widget.controller,
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).colorScheme.surface),
              decoration: InputDecoration(
                border: InputBorder.none,
                errorText: widget.noError ? null : widget.errorMessage,
              ),
            ),
          ),
        ),
        Visibility(
            visible: widget.locked,
            child: IconButton(
              icon: Image.asset(
                image,
                height: 30,
                width: 30,
                color: const Color.fromRGBO(134, 64, 249, 0.7),
              ),
              onPressed: widget.isClickable ? () => {} : null,
            ))
      ],
    );
  }
}
