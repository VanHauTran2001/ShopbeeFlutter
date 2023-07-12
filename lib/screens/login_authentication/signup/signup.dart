// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:saleshoppingapp/screens/login_authentication/login/login.dart';
import '../../../constant/color.dart';
import '../../../constant/routes.dart';
import '../../../firebase_helper/authentication/firebase_auth_helper.dart';
import '../../../widgets/button/primary_button.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool isShowPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back,
                    size: 35, color: ColorInstance.backgroundColor),
              ),
              const SizedBox(height: 10),
              Text(
                getString(context, 'txt_signup'),
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Handle',
                    color: ColorInstance.backgroundColor),
              ),
              const SizedBox(height: 5),
              Text(
                getString(context, 'title_signup'),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Handle',
                    color: ColorInstance.backgroundColor),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: getString(context, 'edt_name'),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: getString(context, 'edt_email'),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelText: getString(context, 'edt_phone'),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: isShowPassword,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    labelText: getString(context, 'edt_password'),
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
              const SizedBox(height: 30),
              PrimaryButton(
                  onPressed: () async {
                    bool isValidated = signupValidation(
                        context,
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                        phoneController.text);
                    if (isValidated) {
                      bool isLogined = await FirebaseAuthHelper.instance.signup(
                          context,
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          phoneController.text);
                      if (isLogined) {
                        showMessage(
                            getString(context, 'message_signup_success'));
                        Routes.instance.pushAndRemoveUntil(
                            widget: Login(), context: context);
                      }
                    }
                  },
                  title: getString(context, 'btn_signup')),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  getString(context, 'txt_already_account'),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Center(
                  child: CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  getString(context, 'txt_signing'),
                  style: TextStyle(
                      color: ColorInstance.backgroundColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
