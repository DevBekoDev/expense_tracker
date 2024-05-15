import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/datetime/datetime_helper.dart';
import 'package:expense_tracker/screens/home/views/graphs.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Expensummary extends StatelessWidget {
  final DateTime startOftheWeek;
  const Expensummary({super.key, required this.startOftheWeek});

  //adjust the max chart level
  double expensecap(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? max = 100;
    List<double> values = [
      value.getDailyexpense()[sunday] ?? 0,
      value.getDailyexpense()[monday] ?? 0,
      value.getDailyexpense()[tuesday] ?? 0,
      value.getDailyexpense()[wednesday] ?? 0,
      value.getDailyexpense()[thursday] ?? 0,
      value.getDailyexpense()[friday] ?? 0,
      value.getDailyexpense()[saturday] ?? 0,
    ];

    values.sort();

    max = values.last * 1.1;
    return max == 0 ? 100 : max;
  }

  double calculateWeekTotal(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.getDailyexpense()[sunday] ?? 0,
      value.getDailyexpense()[monday] ?? 0,
      value.getDailyexpense()[tuesday] ?? 0,
      value.getDailyexpense()[wednesday] ?? 0,
      value.getDailyexpense()[thursday] ?? 0,
      value.getDailyexpense()[friday] ?? 0,
      value.getDailyexpense()[saturday] ?? 0,
    ];
    double total = 0;
    for (var i = 0; i < values.length; i++) {
      total += values[i].toDouble();
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    String sunday =
        convertDateTimetoString(startOftheWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimetoString(startOftheWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimetoString(startOftheWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimetoString(startOftheWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimetoString(startOftheWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimetoString(startOftheWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimetoString(startOftheWeek.add(const Duration(days: 6)));
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: Row(
              children: [
                const Text(
                  "Week Total: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "\$${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday).toInt()}",
                )
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: GraphPage(
                maxY: expensecap(value, sunday, monday, tuesday, wednesday,
                    thursday, friday, saturday),
                monAmount: value.getDailyexpense()[sunday] ?? 0,
                sunAmount: value.getDailyexpense()[monday] ?? 0,
                tueAmount: value.getDailyexpense()[tuesday] ?? 0,
                wedAmount: value.getDailyexpense()[wednesday] ?? 0,
                thurAmount: value.getDailyexpense()[thursday] ?? 0,
                friAmount: value.getDailyexpense()[friday] ?? 0,
                satAmount: value.getDailyexpense()[saturday] ?? 0),
          ),
        ],
      ),
    );
  }
}
