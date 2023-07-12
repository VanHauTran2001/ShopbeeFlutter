import 'package:flutter/material.dart';
import 'package:saleshoppingapp/screens/categories/Category_Screen.dart';
import 'package:saleshoppingapp/screens/map/map_screen.dart';
import 'package:saleshoppingapp/screens/purchased_order/purchased_order.dart';
import 'package:saleshoppingapp/screens/statistical/statistical.dart';
import '../../../constant/asset_images.dart';
import '../../../constant/constants.dart';
import '../../../constant/routes.dart';
import '../../../models/category.dart';

class CategoryWidget extends StatelessWidget {
  String type = "";

  @override
  Widget build(BuildContext context) {
    List<Categories> categoris = [
      Categories(
          imageCategory: AssetsImages.instance.laptop,
          nameCategory: getString(context, 'type_laptop'),
          color: const Color.fromRGBO(255, 228, 181, 100)),
      Categories(
          imageCategory: AssetsImages.instance.watch,
          nameCategory: getString(context, 'type_watch'),
          color: const Color.fromRGBO(238, 254, 237, 100)),
      Categories(
          imageCategory: AssetsImages.instance.phone,
          nameCategory: getString(context, 'type_phone'),
          color: const Color.fromRGBO(237, 219, 252, 100)),
      Categories(
          imageCategory: AssetsImages.instance.map,
          nameCategory: getString(context, 'type_map'),
          color: const Color.fromRGBO(219, 252, 237, 100)),
      Categories(
          imageCategory: AssetsImages.instance.statistical,
          nameCategory: getString(context, 'type_statistical'),
          color: const Color.fromRGBO(252, 219, 237, 100)),
      Categories(
          imageCategory: AssetsImages.instance.purchased,
          nameCategory: getString(context, 'type_purchased'),
          color: const Color.fromRGBO(244, 233, 253, 100)),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: categoris
            .map((category) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: InkWell(
                      onTap: () {
                        int index = categoris.indexOf(category);
                        switch (index) {
                          case 0:
                            type = 'Laptop';
                            Routes.instance.push(
                                widget: Category_Screen(
                                    type: type, name: category.nameCategory),
                                context: context);
                            break;
                          case 1:
                            type = 'Watch';
                            Routes.instance.push(
                                widget: Category_Screen(
                                    type: type, name: category.nameCategory),
                                context: context);
                            break;
                          case 2:
                            type = 'Phone';
                            Routes.instance.push(
                                widget: Category_Screen(
                                    type: type, name: category.nameCategory),
                                context: context);
                            break;
                          case 3:
                            Routes.instance.push(
                                widget: MapScreen(), context: context);
                            break;
                          case 4:
                            Routes.instance.push(
                                widget: StatisticalScreen(), context: context);
                            break;
                          case 5:
                            Routes.instance.push(
                                widget: PurchasedOrder(), context: context);
                            break;
                        }
                      },
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Container(
                          decoration: BoxDecoration(
                              color: category.color,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(category.imageCategory,
                                    width: 50, height: 50),
                              ),
                              const SizedBox(height: 5),
                              Text(category.nameCategory,
                                  style: const TextStyle(fontSize: 17))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
