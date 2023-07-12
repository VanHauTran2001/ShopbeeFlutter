import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../constant/color.dart';
import '../../constant/constants.dart';
import '../../provider/app_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F8),
      body: Column(
        children: [
          AppBar(
            backgroundColor: ColorInstance.backgroundColor,
            automaticallyImplyLeading: false,
            title: Text(
              getString(context, 'title_notification'),
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Handle'),
            ),
            actions: [
              Lottie.asset('assets/json/notification.json', height: 50)
            ],
            elevation: 5,
          ),
          Expanded(
              flex: 1,
              child: provider.notificationList.isEmpty
                  ? Center(
                      child: Text(
                        getString(context, 'message_notification_empty'),
                        style: TextStyle(
                            color: ColorInstance.backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: provider.notificationList.length,
                      itemBuilder: (context, index) {
                        final itemKey = GlobalKey();
                        final notifications = List.from(
                            provider.notificationList.reversed)[index];
                        return Slidable(
                          key: itemKey,
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {
                              final context = itemKey.currentContext;
                              if (context != null) {
                                provider.removeNotification(notifications);
                              }
                            }),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  provider.removeNotification(notifications);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: getString(context, 'txt_delete'),
                                borderRadius: BorderRadius.circular(10),
                              )
                            ],
                          ),
                          child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            elevation: 5,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Lottie.asset(
                                      'assets/json/item_notification.json',
                                      width: 70,
                                      height: 80),
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: SizedBox(
                                        height: 60,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            notifications.contentNoti,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                            maxLines: 3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          notifications.dateNoti,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Handle'),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        );
                      }))
        ],
      ),
    );
  }
}
