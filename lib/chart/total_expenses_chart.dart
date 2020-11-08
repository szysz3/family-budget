import 'package:family_budget/data/data_access.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TotalExpensesChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TotalExpensesChartState();
}

class TotalExpensesChartState extends State<TotalExpensesChart> {
  final double fontSize = 16;
  final double radius = 50;

  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done &&
            !snap.hasError &&
            snap.hasData) {
          return Expanded(
              child: Container(
            width: 250,
            child: PieChart(
              PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                  sections: showingSections(snap.data)),
            ),
          ));
        } else {
          return SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(),
          );
        }
      },
      future: DataAccess().getTotalExpenses(DateTime.now()),
    );
  }

  List<PieChartSectionData> showingSections(
      MapEntry<double, double> totalExpensesEntry) {
    return List.generate(2, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.primary,
            value: totalExpensesEntry.key,
            title: "${totalExpensesEntry.key.round()} PLN",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface),
          );
        case 1:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.secondary,
            value: totalExpensesEntry.value,
            title: "${totalExpensesEntry.value.round()} PLN",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface),
          );
        default:
          return null;
      }
    });
  }
}
