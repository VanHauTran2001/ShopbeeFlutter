// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saleshoppingapp/constant/asset_images.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:saleshoppingapp/firebase_helper/authentication/firebase_auth_helper.dart';
import 'package:saleshoppingapp/firebase_helper/firebase_storage/firebase_storage.dart';
import 'package:saleshoppingapp/models/notification.dart';
import 'package:saleshoppingapp/models/user.dart';
import 'package:saleshoppingapp/screens/login_authentication/login/login.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../constant/color.dart';
import '../../constant/routes.dart';
import '../../provider/app_provider.dart';
import '../../share_preferences/app_shared_preferences.dart';
import '../../widgets/button/primary_button.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String date = DateFormat('HH:mm:ss   dd-MM-yyyy').format(DateTime.now());
  final edtNameController = TextEditingController();
  final edtPhoneController = TextEditingController();
  final edtCurrentPasswordController = TextEditingController();
  final edtNewPasswordController = TextEditingController();
  final edtConfirmPasswordController = TextEditingController();
  final edtCommentController = TextEditingController();
  bool check = false;
  bool isVisibleIconSave = false;
  File? image;

  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    edtNameController.text = provider.getUserInformation.name;
    edtPhoneController.text = provider.getUserInformation.phone;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF35B096),
      body: Column(
        children: [
          Center(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: provider.getUserInformation.avatar == null
                      ? CupertinoButton(
                          onPressed: () {
                            check = true;
                            isVisibleIconSave = true;
                            takePicture();
                          },
                          child: check
                              ? CircleAvatar(
                                  radius: 65,
                                  backgroundImage: FileImage(image!))
                              : CircleAvatar(
                                  radius: 65,
                                  backgroundImage:
                                      AssetImage(AssetsImages.instance.avatar)),
                        )
                      : CupertinoButton(
                          onPressed: () {
                            check = true;
                            isVisibleIconSave = true;
                            takePicture();
                          },
                          child: check
                              ? CircleAvatar(
                                  radius: 65,
                                  backgroundImage: FileImage(image!))
                              : CircleAvatar(
                                  radius: 65,
                                  backgroundImage: NetworkImage(
                                      provider.getUserInformation.avatar!)),
                        ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20, right: 17),
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF35B096),
                      ),
                      child: InkWell(
                        onTap: isVisibleIconSave
                            ? () async {
                                showLoaderDialog(context);
                                String imgUrl = await FirebaseStorageHelper
                                    .instance
                                    .uploadImage(image!);
                                Users users = provider.getUserInformation
                                    .copyWith(avatar: imgUrl);
                                provider.uploadAvatar(context, users);
                                Navigator.of(context).pop();
                              }
                            : () {
                                showMessage(getString(
                                    context, 'message_waring_upload_avatar'));
                              },
                        child: const Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Arc(
                height: 30,
                edge: Edge.TOP,
                arcType: ArcType.CONVEY,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 45, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                color: const Color(0xFFFFBAF2),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: InkWell(
                                  onTap: () {
                                    showDialogChangePassword(context, provider);
                                  },
                                  child: SizedBox(
                                    height: 85,
                                    width: 95,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              AssetsImages.instance.resetPass,
                                              width: 40,
                                              height: 40),
                                        ),
                                        Text(
                                            getString(
                                                context, 'txt_change_pass'),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Handle',
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Card(
                                color: const Color(0xFF93C3FF),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: InkWell(
                                  onTap: () {
                                    showDialogRating(context);
                                  },
                                  child: SizedBox(
                                    height: 85,
                                    width: 95,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              AssetsImages.instance.rate,
                                              width: 40,
                                              height: 40),
                                        ),
                                        Text(getString(context, 'txt_rate'),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Handle',
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Card(
                                color: const Color(0xFFFFD394),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: InkWell(
                                  onTap: () {
                                    showDialogLanguage(context, provider);
                                  },
                                  child: SizedBox(
                                    height: 85,
                                    width: 95,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              AssetsImages.instance.language,
                                              width: 40,
                                              height: 40),
                                        ),
                                        Text(getString(context, 'txt_language'),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Handle',
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        const SizedBox(height: 20),
                        //Name
                        Card(
                          color: const Color(0xFF62BCAE),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(Icons.person_pin,
                                      color: Colors.white),
                                ),
                                Text('${getString(context, 'edt_name')} :',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Handle',
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    provider.getUserInformation.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        //Email
                        Card(
                          color: const Color(0xFF62BCAE),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(Icons.email, color: Colors.white),
                                ),
                                Text('${getString(context, 'edt_email')} :',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Handle',
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    provider.getUserInformation.email,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        //Phone
                        Card(
                          color: const Color(0xFF62BCAE),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(Icons.phone, color: Colors.white),
                                ),
                                Text('${getString(context, 'edt_phone')} :',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Handle',
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    provider.getUserInformation.phone,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                            onPressed: () {
                              showDialogEdit(context, provider);
                            },
                            title: getString(context, 'btn_edit_profile')),
                        const SizedBox(height: 15),
                        Card(
                          color: Colors.red,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: InkWell(
                            onTap: () {
                              FirebaseAuthHelper.instance.signOut();
                              Routes.instance
                                  .push(widget: Login(), context: context);
                            },
                            child: SizedBox(
                              height: 45,
                              width: 145,
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    child: Icon(Icons.logout,
                                        color: Colors.white, size: 25),
                                  ),
                                  Center(
                                    child: Text(
                                        getString(context, 'btn_logout'),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Handle',
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  void showDialogEdit(BuildContext context, AppProvider provider) {
    AlertDialog alert = AlertDialog(
      content: Builder(builder: (context) {
        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: edtNameController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: edtPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(getString(context, 'dialog_cancel'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Users userUpdate = provider.getUserInformation.copyWith(
                            name: edtNameController.text,
                            phone: edtPhoneController.text);
                        provider.updateUserInfoFireStore(context, userUpdate);
                        provider.addNotification(NotificationModel(
                            contentNoti: getString(
                                context, 'notification_change_info_success'),
                            dateNoti: date));
                        Navigator.of(context).pop();
                      },
                      child: Text(getString(context, 'dialog_ok'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showDialogChangePassword(BuildContext context, AppProvider provider) {
    AlertDialog alert = AlertDialog(
      content: Builder(builder: (context) {
        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: edtCurrentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.password),
                    labelText: getString(context, 'txt_current_pass'),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: edtNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.published_with_changes_outlined),
                    labelText: getString(context, 'txt_new_pass'),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: edtConfirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.published_with_changes_outlined),
                    labelText: getString(context, 'txt_confirm_pass'),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(getString(context, 'dialog_cancel'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool isValidated = changePassValidation(
                            context,
                            provider.getUserInformation.passWord,
                            edtCurrentPasswordController.text.trim(),
                            edtNewPasswordController.text.trim(),
                            edtConfirmPasswordController.text.trim());
                        if (isValidated) {
                          bool isChangePass = await FirebaseAuthHelper.instance
                              .changePassword(context,
                                  edtNewPasswordController.text.trim());
                          if (isChangePass) {
                            showMessage(
                                getString(context, 'change_pass_success'));
                            Users passwordUpdate = provider.getUserInformation
                                .copyWith(
                                    passWord:
                                        edtNewPasswordController.text.trim());
                            provider.updatePasswordFireStore(passwordUpdate);
                            edtCurrentPasswordController.text = '';
                            edtNewPasswordController.text = '';
                            edtConfirmPasswordController.text = '';
                            provider.addNotification(NotificationModel(
                                contentNoti: getString(context,
                                    'notification_change_pass_success'),
                                dateNoti: date));
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: Text(getString(context, 'dialog_ok'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showDialogRating(BuildContext context) {
    final dialog = AlertDialog(
      content: Builder(builder: (context) {
        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AssetsImages.instance.welcomeImage,
                  width: 130, height: 130),
              Text(
                getString(context, 'title_rating_app'),
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Handle',
                    color: ColorInstance.backgroundColor),
              ),
              const SizedBox(height: 10),
              Text(
                getString(context, 'message_rating_dialog'),
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              RatingBar.builder(
                  initialRating: 3,
                  itemCount: 5,
                  itemSize: 50,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return const Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                        );
                      case 1:
                        return const Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.deepOrangeAccent,
                        );
                      case 2:
                        return const Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                        );
                      case 3:
                        return const Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                        );
                      case 4:
                        return const Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                      default:
                        return const Icon(Icons.sentiment_very_satisfied,
                            color: Colors.green);
                    }
                  },
                  onRatingUpdate: (rating) {}),
              const SizedBox(height: 15),
              TextFormField(
                controller: edtCommentController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.comment),
                    labelText: getString(context, 'txt_comment'),
                    labelStyle:
                        TextStyle(color: ColorInstance.backgroundColor)),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorInstance.backgroundColor),
                child: Text(getString(context, 'btn_submit'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        );
      }),
    );
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => dialog,
    );
  }

  void showDialogLanguage(BuildContext context, AppProvider provider) {
    final dialog = AlertDialog(
      content: Builder(builder: (context) {
        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _changeLanguage("ja", context, provider);
                    Navigator.of(context).pop();
                  },
                  icon: Image.asset(AssetsImages.instance.japan,
                      width: 35, height: 35),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      getString(context, 'txt_japan'),
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Handle'),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.teal),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _changeLanguage("en", context, provider);
                    Navigator.of(context).pop();
                  },
                  icon: Image.asset(AssetsImages.instance.english,
                      width: 35, height: 35),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      getString(context, 'txt_english'),
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Handle'),
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.teal),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                ),
              )
            ],
          ),
        );
      }),
    );
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => dialog,
    );
  }

  void _changeLanguage(
      String language, BuildContext context, AppProvider provider) async {
    Locale selectedLocale = await AppSharedPreferences().setLocale(language);
    provider.setLocale(selectedLocale);
  }
}
