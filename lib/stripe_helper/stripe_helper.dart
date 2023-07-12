// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:saleshoppingapp/constant/constants.dart';
import 'package:http/http.dart' as http;
import 'package:saleshoppingapp/firebase_helper/firestore_database/firebase_firestore.dart';
import 'package:saleshoppingapp/screens/home/menu_home.dart';
import '../constant/routes.dart';
import '../models/notification.dart';
import '../models/product.dart';
import '../provider/app_provider.dart';

class StripeHelper {
  final formatter = NumberFormat('#,###', 'en_US');
  String secreteKey =
      "sk_test_51LKdcILCmPlhYQx0pI3RRTHauYBPRGz1mGHuEg5F18R03Q7F30DDhyDBwh5CkKaP29oeDtXRdgdkjhffl88L1d5c00zd0YkIC5";
  static StripeHelper instance = StripeHelper();
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(
      BuildContext context,
      AppProvider provider,
      String name,
      String phone,
      String address,
      String payment,
      String status,
      String dateOrder,
      double totalPrice,
      String priceDollar,
      List<Product> list) async {
    try {
      paymentIntent = await createPaymentIntent(priceDollar, 'USD');
      var pay = const PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.light,
                  merchantDisplayName: 'HauTV',
                  googlePay: pay))
          .then((value) => {});
      displayPaymentSheet(context, provider, name, phone, address, payment,
          status, dateOrder, totalPrice, priceDollar, list);
    } catch (err) {
      showMessage(err.toString());
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secreteKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (e) {
      showMessage(e.toString());
    }
  }

  displayPaymentSheet(
      BuildContext context,
      AppProvider provider,
      String name,
      String phone,
      String address,
      String payment,
      String status,
      String dateOrder,
      double totalPrice,
      String priceDollar,
      List<Product> list) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        bool value = await FirebaseFirestoreHelper.instance
            .addOrderProductToFirebase(context, name, phone, address, payment,
                status, dateOrder, totalPrice, list);

        if (value) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            showCloseIcon: true,
            title: getString(context, 'title_payment_success'),
            titleTextStyle:
                const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            desc: getString(context, 'message_payment_success'),
            descTextStyle: const TextStyle(fontSize: 17),
            btnOkText: getString(context, 'dialog_ok'),
            btnOkOnPress: () {
              provider.addNotification(NotificationModel(
                  contentNoti:
                      '${getString(context, 'notification_order_success')} ${formatter.format(double.parse(priceDollar))}\$',
                  dateNoti: dateOrder));
              provider.cleanCart();
              Routes.instance.push(widget: MenuHome(), context: context);
            },
          ).show();
        }
      });
    } catch (e) {
      showMessage(e.toString());
    }
  }
}
