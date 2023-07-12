import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saleshoppingapp/constant/asset_images.dart';
import 'package:saleshoppingapp/constant/color.dart';
import 'package:saleshoppingapp/screens/login_authentication/login/login.dart';
import 'package:saleshoppingapp/constant/constants.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorInstance.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getString(context, "welcome"),
              style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cookie',
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              getString(context, "title_splash"),
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MarkScript',
                  color: Colors.white),
            ),
            Image.asset(AssetsImages.instance.welcomeImage, height: 280),
            const SizedBox(height: 30),
            const CupertinoActivityIndicator(
              color: Colors.white,
              radius: 30,
            )
          ],
        ),
      ),
    );
  }
}
