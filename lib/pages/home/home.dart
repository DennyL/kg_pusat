//ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:kg_pusat/dataclass.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SfCartesianChart(
              enableAxisAnimation: true,
              legend: Legend(
                textStyle: Theme.of(context).textTheme.subtitle2,
                isVisible: true,
                position: LegendPosition.top,
                alignment: ChartAlignment.center,
                overflowMode: LegendItemOverflowMode.scroll,
                isResponsive: true,

              ),

              // Initialize category axis
              primaryXAxis: CategoryAxis(),
              series: <LineSeries<TransactionData, String>>[
                LineSeries<TransactionData, String>(
                    // Bind data source
                    color: Colors.green,
                    name: "Pemasukan",
                    dataSource: [],
                    xValueMapper: (TransactionData sales, _) => sales.year,
                    yValueMapper: (TransactionData sales, _) => sales.amount),
                LineSeries<TransactionData, String>(
                    // Bind data source
                    color: Colors.red,
                    name: "Pengeluaran",
                    dataSource: [],
                    xValueMapper: (TransactionData sales, _) => sales.year,
                    yValueMapper: (TransactionData sales, _) => sales.amount),
                LineSeries<TransactionData, String>(
                    // Bind data source
                    color: Colors.yellow,
                    name: "Saldo",
                    dataSource: [],
                    xValueMapper: (TransactionData sales, _) => sales.year,
                    yValueMapper: (TransactionData sales, _) => sales.amount)
              ],
            ),
          )
        ],
      ),
    );
  }
}
