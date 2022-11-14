import 'package:animal_house/core/constant/app_constant.dart';
import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/main.dart';
import 'package:animal_house/presintaions/common/hero_image.dart';
import 'package:animal_house/presintaions/common/text_style.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const HeroImage(welcomeImage: AppConst.loginImage),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 18, right: 18, top: Dimensions.screenHeight * 0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyles.titleTextStyle,
                  ),
                  Text(
                    'Login to manage your account.',
                    style: TextStyles.tageLineStyle,
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: Colors.white),
                          ),
                        ),
                        validator: (String? value) {
                          String pattern =
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?)*$";
                          RegExp regex = RegExp(pattern);
                          if (value!.isEmpty || !regex.hasMatch(value)) {
                            return "invalid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(
                              obscureText
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: Colors.white,
                            ),
                          ),
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: Colors.white),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.5, color: Colors.white),
                          ),
                        ),
                        obscureText: obscureText,
                        validator: (String? value) {
                          if (value!.isEmpty || value.length < 6) {
                            return "invalid password";
                          }
                          return null;
                        },
                      ),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Consumer<UserProvider>(
                    builder: (context, state, _) {
                      return ElevatedButton(
                        onPressed: ()async {
                          setState(() {
                            _formKey.currentState!.validate();
                          });
                          if (_formKey.currentState!.validate()) {
                           await state.signIn(
                              context,
                              emailController.text,
                              passwordController.text,
                            )
                                .then((value) {
                              if (value) {
                                Navigator.pushReplacementNamed(
                                  context,HOME_SCREEN
                                );
                              }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: const Size(1024, 60),
                            primary: const Color.fromRGBO(99, 139, 156, 1)),
                        child: state.loading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : const Text(
                                'LOGIN',
                                style: TextStyle(fontSize: 16),
                              ),
                      );
                    },
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SIGNUP_SCREEN);
                    
                      },
                      child: Text("Don't Have an Account? Sign up",
                          style: TextStyles.bodyTextStyle
                      
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
