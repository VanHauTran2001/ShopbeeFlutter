// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saleshoppingapp/constant/asset_images.dart';
import 'package:saleshoppingapp/constant/color.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:saleshoppingapp/constant/routes.dart';
import 'package:saleshoppingapp/firebase_helper/authentication/firebase_auth_helper.dart';
import 'package:saleshoppingapp/screens/forgot_password/forgot_password.dart';
import 'package:saleshoppingapp/screens/home/menu_home.dart';
import 'package:saleshoppingapp/screens/login_authentication/signup/signup.dart';
import 'package:saleshoppingapp/widgets/button/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  bool isShowPassword = true;
  bool remember = false;

  double screenHeightSize(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return screenSize.height; // Chieu cao man hinh
  }

  // Save login data
  Future<void> saveLoginData(
      String username, String password, bool remember) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (remember) {
      prefs.setString('username', username);
      prefs.setString('password', password);
      prefs.setBool('check', remember);
    } else {
      prefs.remove('username');
      prefs.remove('password');
      prefs.remove('check');
    }
  }

  @override
  void initState() {
    super.initState();
    getLoginData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(context, "txt_login"),
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Handle',
                    color: ColorInstance.backgroundColor),
              ),
              const SizedBox(height: 5),
              Text(
                getString(context, "title_login"),
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Handle',
                    color: ColorInstance.backgroundColor),
              ),
              Center(child: Lottie.asset('assets/json/login.json', width: 200)),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: getString(context, "edt_email"),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passWordController,
                obscureText: isShowPassword,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    labelText: getString(context, "edt_password"),
                    labelStyle: TextStyle(color: ColorInstance.backgroundColor),
                    suffixIcon: CupertinoButton(
                      child: Icon(
                        isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: ColorInstance.backgroundColor,
                      ),
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                    )),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                      value: remember,
                      activeColor: ColorInstance.backgroundColor,
                      fillColor: MaterialStateProperty.all(
                          ColorInstance.backgroundColor),
                      onChanged: (value) {
                        setState(() {
                          remember = value!;
                        });
                      }),
                  Text(getString(context, "txt_remember"),
                      style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  InkWell(
                      onTap: () {
                        Routes.instance
                            .push(widget: ForgotPassword(), context: context);
                      },
                      child: Text(getString(context, "txt_forgot_password"),
                          style: const TextStyle(
                              color: Colors.teal,
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)))
                ],
              ),
              const SizedBox(height: 10),
              PrimaryButton(
                  onPressed: () async {
                    bool isValidated = loginValidation(
                        context, emailController.text, passWordController.text);
                    if (isValidated) {
                      bool isLogined = await FirebaseAuthHelper.instance.login(
                          context,
                          emailController.text,
                          passWordController.text);
                      if (isLogined) {
                        showMessage(
                            getString(context, "message_login_success"));
                        // Save the login data
                        saveLoginData(emailController.text,
                            passWordController.text, remember);
                        Routes.instance
                            .push(widget: MenuHome(), context: context);
                      }
                    }
                  },
                  title: getString(context, "txt_login")),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  getString(context, "txt_no_account"),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Center(
                  child: CupertinoButton(
                onPressed: () {
                  Routes.instance.push(widget: Signup(), context: context);
                },
                child: Text(
                  getString(context, "txt_create_account"),
                  style: TextStyle(
                      color: ColorInstance.backgroundColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                ),
              )),
              const Spacer(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.facebook, color: Colors.blue, size: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(AssetsImages.instance.imgGoogle,
                          height: 38),
                    ),
                    Image.asset(AssetsImages.instance.imgTwitter, height: 30)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Retrieve login data
  void getLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    bool? checked = prefs.getBool('check');
    if (checked!) {
      emailController.text = username!;
      passWordController.text = password!;
      setState(() {
        remember = checked;
      });
    }
  }
}
