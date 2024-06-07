import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:business_management_app/models/employee_performance.dart';

class EmployeePerformanceChart extends StatelessWidget {
  final List<EmployeePerformance> data;

  EmployeePerformanceChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<EmployeePerformance, String>> series = [
      charts.Series(
        id: "EmployeePerformance",
        data: data,
        domainFn: (EmployeePerformance performance, _) => performance.employeeName,
        measureFn: (EmployeePerformance performance, _) => performance.kpiScore,
        colorFn: (EmployeePerformance performance, _) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Employee Performance",
                style: Theme.of(context).textTheme.headline6,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

