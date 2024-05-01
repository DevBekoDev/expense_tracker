import 'package:expense_tracker/data/bar_graph/bar_graph.dart';

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;

  List<barGraph> barData = [];
  BarData(
      {required this.sunAmount,
      required this.monAmount,
      required this.tueAmount,
      required this.wedAmount,
      required this.thurAmount,
      required this.friAmount,
      required this.satAmount});

  void createBarData() {
    barData = [
      barGraph(x: 0, y: sunAmount),
      barGraph(x: 1, y: monAmount),
      barGraph(x: 2, y: tueAmount),
      barGraph(x: 3, y: wedAmount),
      barGraph(x: 4, y: thurAmount),
      barGraph(x: 5, y: friAmount),
      barGraph(x: 6, y: satAmount),
    ];
  }
}
