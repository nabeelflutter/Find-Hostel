import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practices/views/validator/validation.dart';
import '../components/customtextformfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFieldKey =
  GlobalKey<FormFieldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: key,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // image container
              SizedBox(
                height: height * .05,
                child: const Text(
                  "Reset Password",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
              ),
              // email text-field
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
              // password text-field
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if(key.currentState!.validate()){
                      _auth.sendPasswordResetEmail(email: emailController.text).then((value){
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.teal,content: Text('Check Your email')));
                      });
                    }
                  },
                  child: const Text('Send Request')),
              // forget password button
              // space
              // login button
              // space
            ],
          ),
        ),
      ),
    );
  }
}
