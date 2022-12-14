import 'package:animal_house/core/constant/app_constant.dart';
import 'package:animal_house/core/utills/dimensions.dart';
import 'package:animal_house/main.dart';
import 'package:animal_house/presintaions/widgets/hero_image.dart';
import 'package:animal_house/presintaions/widgets/text_style.dart';
import 'package:animal_house/presintaions/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

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
                  left: 18, right: 18, top: Dimensions.screenHeight * 0.15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyles.titleTextStyle,
                  ),
                  Text(
                    'Signup to manage your account.',
                    style: TextStyles.tageLineStyle,
                  ),
                  const SizedBox(height: 15),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
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
                          if (value!.length < 3) {
                            return "invalid name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          // suffixIcon: IconButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       obscureText = !obscureText;
                          //     });
                          //   },
                          //   icon: Icon(
                          //     obscureText
                          //         ? Icons.remove_red_eye_outlined
                          //         : Icons.remove_red_eye,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          border: OutlineInputBorder(),
                          labelText: 'Password',
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
                        //obscureText: obscureText,
                        validator: (String? value) {
                          if (value!.isEmpty || value.length < 6) {
                            return "invalid password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: conPasswordController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          // suffixIcon: IconButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       obscureText = !obscureText;
                          //     });
                          //   },
                          //   icon: Icon(
                          //     obscureText
                          //         ? Icons.remove_red_eye_outlined
                          //         : Icons.remove_red_eye,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
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
                        //obscureText: obscureText,
                        validator: (String? value) {
                          if (value != passwordController.text) {
                            return "invalid confirm password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone',
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
                        obscureText: obscureText,
                        validator: (String? value) {
                          if (value!.isEmpty || value.length != 10) {
                            return "invalid phone Number";
                          }
                          return null;
                        },
                      ),
                    ]),
                  ),
                  const SizedBox(height: 15),
                  Consumer<UserProvider>(
                    builder: (context, state, _) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _formKey.currentState!.validate();
                          });
                          if (_formKey.currentState!.validate()) {
                            state
                                .signUp(
                                    context,
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    phoneController.text)
                                .then((value) {
                              Navigator.pushReplacementNamed(
                                  context, MY_APP_SCREEN);
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
                                    color: Colors.white))
                            : const Text(
                                'SIGNUP',
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
                        Navigator.pop(context);
                      },
                      child: Text("Already Have an Account? Sign in",
                          style: TextStyles.bodyTextStyle),
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
