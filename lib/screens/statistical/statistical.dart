// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:saleshoppingapp/models/charts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constant/color.dart';
import '../../constant/constants.dart';
import 'package:http/http.dart' as http;
import '../../models/product.dart';

class StatisticalScreen extends StatefulWidget {
  @override
  State<StatisticalScreen> createState() => _StatisticalScreenState();
}

class _StatisticalScreenState extends State<StatisticalScreen> {
  final List<ChartData> _chartData = [];
  late TooltipBehavior _tooltipBehavior;
  List<Product> productList = [];
  bool _loading = false;

  Future<void> fetData() async {
    setState(() {
      _loading = true;
    });
    const url =
        'https://tranvanhau2001.000webhostapp.com/Server/getstatistical.php';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body);
      final results = json['results'] as List<dynamic>;
      setState(() {
        productList = results.map((data) => Product.fromJson(data)).toList();
        _chartData.clear();
        for (int i = 0; i < productList.length; i++) {
          String name = productList[i].NameProduct;
          int sold = int.parse(productList[i].SelledProduct);
          _chartData.add(ChartData(name, sold));
        }
        _loading = false;
      });
    } else {
      throw Exception(getString(context, 'txt_failed_fetch_data'));
    }
  }

  @override
  void initState() {
    fetData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: ColorInstance.backgroundColor,
            title: Text(
              getString(context, 'type_statistical'),
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
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: ColorInstance.backgroundColor),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 210,
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                getString(context, 'txt_title_statistical'),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: ColorInstance.backgroundColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Handle'),
                                textAlign: TextAlign.center,
                              ),
                              Lottie.asset('assets/json/chart.json',
                                  height: 130),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Center(
                          child: SfCircularChart(
                            legend: const Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              position: LegendPosition.bottom,
                            ),
                            tooltipBehavior: _tooltipBehavior,
                            series: [
                              PieSeries<ChartData, String>(
                                dataSource: _chartData,
                                xValueMapper: (ChartData data, _) =>
                                    data.nameProduct,
                                yValueMapper: (ChartData data, _) =>
                                    data.selled,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                enableTooltip: true,
                              )
                            ],
                          ),
                        ))
                      ],
                    ))
        ],
      ),
    );
  }
}
