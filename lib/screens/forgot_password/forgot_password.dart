// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saleshoppingapp/constant/color.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:saleshoppingapp/constant/routes.dart';
import 'package:saleshoppingapp/firebase_helper/authentication/firebase_auth_helper.dart';
import 'package:saleshoppingapp/screens/login_authentication/login/login.dart';
import '../../widgets/button/primary_button.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.teal,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Center(
                      child: Text(getString(context, "title_forgot_password"),
                          style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal)),
                    ),
                  ),
                ],
              ),
            ),
            Center(
                child: Lottie.asset('assets/json/password.json', width: 250)),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getString(context, "title_forgot_password"),
                        style: TextStyle(
                            color: ColorInstance.backgroundColor,
                            fontSize: 40,
                            fontFamily: 'Handle',
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(
                      getString(context, "txt_message_forgot_pass"),
                      style: TextStyle(
                          color: ColorInstance.backgroundColor, fontSize: 16),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: getString(context, "edt_email"),
                          labelStyle:
                              TextStyle(color: ColorInstance.backgroundColor)),
                    ),
                    const SizedBox(height: 30),
                    PrimaryButton(
                        onPressed: () async {
                          bool isValidated = emailValidation(
                              context, emailController.text.trim());
                          if (isValidated) {
                            bool isResetPass = await FirebaseAuthHelper.instance
                                .forgotPassword(
                                    context, emailController.text.trim());
                            if (isResetPass) {
                              showMessage(getString(
                                  context, "txt_reset_password_success"));
                              Routes.instance
                                  .push(widget: Login(), context: context);
                            }
                          }
                        },
                        title: getString(context, "txt_continue")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
