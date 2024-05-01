import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/datetime/datetime_helper.dart';
import 'package:expense_tracker/models/items.dart';
import 'package:flutter/cupertino.dart';

class ExpenseData extends ChangeNotifier {
  // list all items
  List<ExpenseItems> overallList = [];
  List<double> incomeList = [];
  List<double> expenseList = [];

//get database
  final db = HiveDatabase();
  //int totalBalance = 0;
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallList = db.readData();
      incomeList = db.readIncomeList();
      expenseList = db.readExpenseList();
    }
  }

  //get total income from database

  // get last income
  double getLastIncome() {
    if (incomeList.isEmpty) {
      return 0.0;
    }
    return incomeList[incomeList.length - 1];
  }

  // get last expense
  double getLastExpense() {
    if (expenseList.isEmpty) {
      return 0.0;
    }
    return expenseList[expenseList.length - 1];
  }

  //add income
  void addNewIncome(double newIncome) {
    incomeList.add(newIncome);
    db.saveIncomeValue(incomeList);
    db.saveTotalBalance(incomeList, expenseList);
    notifyListeners();
  }

  // get the list
  List<ExpenseItems> getALLItemsList() {
    return overallList;
  }

  // add new item
  void addNewItem(ExpenseItems newItem) {
    overallList.add(newItem);
    expenseList.add(double.parse(newItem.amount));
    db.saveExpenseValues(expenseList);
    db.saveTotalBalance(incomeList, expenseList);
    notifyListeners();
  }

  // delete item
  void deleteItem(ExpenseItems item) {
    overallList.remove(item);
    notifyListeners();
  }

  //get day of the week
  String getDayName(DateTime time) {
    switch (time.weekday) {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thur";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";

      default:
        return "";
    }
  }

  // start of the chart
  DateTime startOfChart() {
    DateTime? startOftheWee;
    // db.saveTotalBalanceValue(incomeList[incomeList.length - 1].toInt(),
    // expenseList[expenseList.length - 1].toInt());
    db.saveData(overallList);

    DateTime today = DateTime.now();

    for (var i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOftheWee = today.subtract(Duration(days: i));
      }
    }
    return startOftheWee!;
  }

  //show total spent in the day
  Map<String, double> getDailyexpense() {
    Map<String, double> dailyExpenseSummury = {};

    for (var expense in overallList) {
      String date = convertDateTimetoString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummury.containsKey(date)) {
        double currentAmount = dailyExpenseSummury[date]!;
        currentAmount += amount;
        dailyExpenseSummury[date] = currentAmount;
      } else {
        dailyExpenseSummury.addAll({date: amount});
      }
    }
    // db.saveTotalBalanceValue();
    return dailyExpenseSummury;
  }
}
