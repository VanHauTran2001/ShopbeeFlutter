import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saleshoppingapp/constant/color.dart';
import '../localization/app_localization.dart';

const String ENGLISH = "en";
const String JAPAN = "ja";

String getString(BuildContext context, String key) {
  return AppLocalization.of(context).getTranslatedValue(key).toString();
}

void showMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(builder: (context) {
      return SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: ColorInstance.backgroundColor,
            ),
            const SizedBox(
              height: 18.0,
            ),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: Text(getString(context, 'txt_loading'))),
          ],
        ),
      );
    }),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

bool loginValidation(BuildContext context, String email, String password) {
  if (email.isEmpty && password.isEmpty) {
    showMessage(getString(context, 'message_data_not_empty'));
    return false;
  } else if (email.isEmpty) {
    showMessage(getString(context, 'message_email_not_empty'));
    return false;
  } else if (password.isEmpty) {
    showMessage(getString(context, 'message_password_not_empty'));
    return false;
  } else {
    return true;
  }
}

bool emailValidation(BuildContext context, String email) {
  if (email.isEmpty) {
    showMessage(getString(context, 'message_email_not_empty'));
    return false;
  } else {
    return true;
  }
}

bool signupValidation(BuildContext context, String userName, String email,
    String password, String phone) {
  if (email.isEmpty && password.isEmpty && userName.isEmpty && phone.isEmpty) {
    showMessage(getString(context, 'message_data_not_empty'));
    return false;
  } else if (email.isEmpty) {
    showMessage(getString(context, 'message_email_not_empty'));
    return false;
  } else if (password.isEmpty) {
    showMessage(getString(context, 'message_password_not_empty'));
    return false;
  } else if (userName.isEmpty) {
    showMessage(getString(context, 'message_name_not_empty'));
    return false;
  } else if (phone.isEmpty) {
    showMessage(getString(context, 'message_phone_not_empty'));
    return false;
  } else {
    return true;
  }
}

bool changePassValidation(BuildContext context, String oldPass,
    String currentPass, String newPass, String confirmPass) {
  if (currentPass.isEmpty) {
    showMessage(getString(context, 'message_current_pass_not_empty'));
    return false;
  } else if (newPass.isEmpty) {
    showMessage(getString(context, 'message_new_pass_not_empty'));
    return false;
  } else if (confirmPass.isEmpty) {
    showMessage(getString(context, 'message_confirm_pass_not_empty'));
    return false;
  } else if (oldPass != currentPass) {
    showMessage(getString(context, 'message_current_pass_incorrect'));
    return false;
  } else if (newPass != confirmPass) {
    showMessage(getString(context, 'message_confirm_pass_incorrect'));
    return false;
  } else {
    return true;
  }
}
