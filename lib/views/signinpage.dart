import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:practices/views/registerpage.dart';
import 'package:practices/views/validator/validation.dart';
import '../components/customtextformfield.dart';
import 'addhostel.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFieldKey =
      GlobalKey<FormFieldState>();
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
  Color emailColor = Colors.black26;
  Color passwordColor = Colors.black26;
  Color eyeColor = Colors.black26;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void login() {
    setState(() {
      isLoading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
     setState(() {
       isLoading = false;
     });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          value.user!.email.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AddHostel(),), (route) => false);
    })
        .onError((error, stackTrace) {
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
    return Scaffold(
      // backgroundColor
      backgroundColor: Colors.white,
      // singlechildscrollview
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
                  "Login Now",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: height * .04,
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
                    )),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if(key.currentState!.validate()){
                      login();
                    }
                  },
                  child:isLoading == true?const CircularProgressIndicator(color: Colors.white,): const Text('Login')),
              // forget password button
              SizedBox(
                height: height * .03,
                child: Padding(
                  padding: EdgeInsets.only(left: width * .55),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword(),));
                      },
                      child: const Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.teal, fontSize: 16),
                      )),
                ),
              ),
              // space
              SizedBox(
                height: height * .02,
              ),
              // login button
              // space
              SizedBox(
                height: height * .03,
              ),
              const Divider(),
              SizedBox(
                height: height * .01,
              ),
              // don't have account text
              SizedBox(
                height: height * .04,
                child: RichText(
                    text: TextSpan(children: <InlineSpan>[
                  const TextSpan(
                      text: "Don't have an account! ",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: "Register",
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 18,
                        // fontWeight: FontWeight.bold
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                              (route) => false);
                        })
                ])),
              ),
              // space
              SizedBox(
                height: height * .05,
              )
            ],
          ),
        ),
      ),
    );
  }
}
