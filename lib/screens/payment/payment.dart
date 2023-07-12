// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saleshoppingapp/constant/asset_images.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:saleshoppingapp/firebase_helper/firestore_database/firebase_firestore.dart';
import 'package:saleshoppingapp/screens/home/menu_home.dart';
import 'package:saleshoppingapp/stripe_helper/stripe_helper.dart';
import '../../constant/color.dart';
import '../../constant/constants.dart';
import '../../constant/routes.dart';
import '../../models/notification.dart';
import '../../provider/app_provider.dart';
import '../../widgets/button/primary_button.dart';

class Payment extends StatefulWidget {
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final formatter = NumberFormat('#,###', 'en_US');
  final edtAddressController = TextEditingController();
  String formattedDate =
      DateFormat('HH:mm:ss   dd-MM-yyyy').format(DateTime.now());
  int groupValue = 1;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: ColorInstance.backgroundColor,
            title: Text(
              getString(context, 'txt_payment'),
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Handle'),
            ),
            elevation: 5,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getString(context, 'txt_user_information'),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorInstance.backgroundColor,
                        fontFamily: 'Handle'),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFE7FFF9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${getString(context, 'edt_name')}：',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ColorInstance.backgroundColor,
                                    fontFamily: 'Handle'),
                              ),
                              const SizedBox(width: 10),
                              Text(provider.getUserInformation.name,
                                  style: TextStyle(
                                      color: ColorInstance.backgroundColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                '${getString(context, 'edt_phone')}：',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ColorInstance.backgroundColor,
                                    fontFamily: 'Handle'),
                              ),
                              const SizedBox(width: 10),
                              Text(provider.getUserInformation.phone,
                                  style: TextStyle(
                                      color: ColorInstance.backgroundColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                getString(context, 'txt_total'),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ColorInstance.backgroundColor,
                                    fontFamily: 'Handle'),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                  '${formatter.format(provider.totalPrice())}đ',
                                  style: TextStyle(
                                      color: ColorInstance.backgroundColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: TextFormField(
                              controller: edtAddressController,
                              decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.location_on_outlined),
                                  labelText: getString(context, 'edt_address'),
                                  labelStyle: TextStyle(
                                      color: ColorInstance.backgroundColor)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    getString(context, 'txt_payment_methods'),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorInstance.backgroundColor,
                        fontFamily: 'Handle'),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: ColorInstance.backgroundColor, width: 3.0)),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: groupValue,
                          onChanged: (value) {
                            setState(() {
                              groupValue = value!;
                            });
                          },
                          fillColor: MaterialStateProperty.all(
                              ColorInstance.backgroundColor),
                        ),
                        Image.asset(AssetsImages.instance.money,
                            height: 30, width: 35),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          getString(context, 'txt_cash_on_delivery'),
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: ColorInstance.backgroundColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: ColorInstance.backgroundColor, width: 3.0)),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Radio(
                          value: 2,
                          groupValue: groupValue,
                          onChanged: (value) {
                            setState(() {
                              groupValue = value!;
                            });
                          },
                          fillColor: MaterialStateProperty.all(
                              ColorInstance.backgroundColor),
                        ),
                        Image.asset(AssetsImages.instance.card,
                            width: 35, height: 35),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          getString(context, 'txt_pay_online'),
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: ColorInstance.backgroundColor),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PrimaryButton(
                      onPressed: () async {
                        if (edtAddressController.text.isEmpty) {
                          showMessage(
                              getString(context, 'message_address_not_empty'));
                        } else {
                          if (groupValue == 1) {
                            bool value = await FirebaseFirestoreHelper.instance
                                .addOrderProductToFirebase(
                                    context,
                                    provider.getUserInformation.name,
                                    provider.getUserInformation.phone,
                                    edtAddressController.text,
                                    getString(context, 'txt_cash_on_delivery'),
                                    getString(context, 'txt_pending'),
                                    formattedDate,
                                    provider.totalPrice(),
                                    provider.cartList);

                            if (value) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.SUCCES,
                                animType: AnimType.BOTTOMSLIDE,
                                showCloseIcon: true,
                                title:
                                    getString(context, 'title_payment_success'),
                                titleTextStyle: const TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.bold),
                                desc: getString(
                                    context, 'message_payment_success'),
                                descTextStyle: const TextStyle(fontSize: 17),
                                btnOkText: getString(context, 'dialog_ok'),
                                btnOkOnPress: () {
                                  provider.addNotification(NotificationModel(
                                      contentNoti:
                                          '${getString(context, 'notification_order_success')} ${formatter.format(provider.totalPrice())} đ',
                                      dateNoti: formattedDate));
                                  provider.cleanCart();
                                  Routes.instance.push(
                                      widget: MenuHome(), context: context);
                                },
                              ).show();
                            }
                          } else {
                            int price =
                                double.parse(provider.totalPrice().toString())
                                    .round()
                                    .toInt();
                            int total = ((price / 24000) * 100).toInt();
                            await StripeHelper.instance.makePayment(
                                context,
                                provider,
                                provider.getUserInformation.name,
                                provider.getUserInformation.phone,
                                edtAddressController.text,
                                getString(context, 'txt_pay_online'),
                                getString(context, 'txt_pending'),
                                formattedDate,
                                provider.totalPrice(),
                                total.toString(),
                                provider.cartList);
                          }
                        }
                      },
                      title: getString(context, 'txt_payment')),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
