import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:practices/components/customtextformfield.dart';
import 'package:practices/views/signinpage.dart';
import 'package:practices/views/validator/validation.dart';

import 'addhostel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;

  // controllers

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // global keys
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> confirmPasswordFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> firstNameFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> lastNameFieldKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> phoneNumberFieldKey =
      GlobalKey<FormFieldState>();

  // show password icon control provider
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
  ValueNotifier<bool> isloading = ValueNotifier<bool>(true);

  // colors for fields
  Color firstNameColor = Colors.black26;
  Color lastNameColor = Colors.black26;
  Color phoneNumberColor = Colors.black26;
  Color emailColor = Colors.black26;
  Color passwordColor = Colors.black26;
  Color confirmPasswordColor = Colors.black26;
  Color eyeColor = Colors.black26;
  Color eyeColor1 = Colors.black26;

// dispose method
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    // final provider = Provider.of<LoadingProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: key,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * .07,
              ),
              // image container background

              SizedBox(
                height: height * .05,
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: height * .04,
              ),
              // first name text field
              // space
              SizedBox(
                height: height * .01,
              ),
              // last name text field
              SizedBox(
                  height: height * .11,
                  width: width,
                  child: CustomTextFormField(
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      return FieldValidator.validateEmail(value);
                    },
                    controller: emailController,
                    hint: 'Email', textCapitalization: TextCapitalization.none,
                  )),
              // space
              SizedBox(
                height: height * .01,
              ),
              // phone number text field
              // space
              // email text field
              // space
              SizedBox(
                height: height * .01,
              ),
              // password text field
              ValueListenableBuilder(
                valueListenable: obscureText,
                builder: (context, value, child) => SizedBox(
                  height: height * .11,
                  width: width,
                  child: CustomTextFormField(
                    validator: (value) {
                      return FieldValidator.validatePassword(value);
                    },
                    controller: passwordController,
                    hint: 'Password',
                    sufixIcon: InkWell(
                        onTap: () {
                          obscureText.value = !obscureText.value;
                        },
                        child: Icon(obscureText.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility)), textCapitalization: TextCapitalization.none,
                  ),
                ),
              ),
              // space
              SizedBox(
                height: height * .01,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (key.currentState!.validate()) {
                      //   value.setLoading(true);
                      setState(() {
                        isLoading = true;
                      });
                      _auth
                          .createUserWithEmailAndPassword(
                              email: emailController.text.toString(),
                              password: passwordController.text.toString())
                          .then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Successfully Register',
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                          backgroundColor: Colors.teal,
                        ));
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AddHostel(),), (route) => false);

                      }).onError((error, stackTrace) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            error.toString(),
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                          backgroundColor: Colors.teal,
                        ));
                      });
                    }
                  },
                  child: isLoading == true
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Register')),
              // confirm password text field
              // space
              // sign up button
              // space
              const Divider(),
              SizedBox(
                height: height * .01,
              ),
              // have already account text
              SizedBox(
                height: height * .04,
                child: RichText(
                    text: TextSpan(children: <InlineSpan>[
                  const TextSpan(
                      text: "Already have an account! ",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: "Sign in",
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 18,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false);
                        })
                ])),
              ),
              // space
              SizedBox(
                height: height * .04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
