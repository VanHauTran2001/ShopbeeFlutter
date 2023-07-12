import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:saleshoppingapp/constant/theme.dart';
import 'package:saleshoppingapp/firebase_helper/authentication/firebase_auth_helper.dart';
import 'package:saleshoppingapp/localization/app_localization.dart';
import 'package:saleshoppingapp/provider/app_provider.dart';
import 'package:saleshoppingapp/screens/splash/splash.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51LKdcILCmPlhYQx0U6PqKxvQfRWlLn0RVWnYPCRe90qa1eTpjpgN81bgvuA1nLVKyGrOuVGSWYiNtpp8HbBjwdgz00oIJqL5i1";
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => AppProvider(),
      builder: (context,child){
        final provider = Provider.of<AppProvider>(context);
        return MaterialApp(
          locale: provider.locale,
          localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalization.delegate,
          ],
          supportedLocales: const [
            Locale('en','US'),
            Locale('ja','JA'),
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales){
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale!.languageCode &&
                  locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
          title: 'Sale Shopping App',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshots) {
              return Splash();
            },
          ),
        );
      },
    );
  }
}
