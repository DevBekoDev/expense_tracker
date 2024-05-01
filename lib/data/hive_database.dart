import 'package:expense_tracker/models/items.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  final myBox = Hive.box("expense");

  // save whole data to hive
  void saveData(List<ExpenseItems> allexpense) {
    List<List<dynamic>> allExpenseFormat = [];
    for (var expense in allexpense) {
      List<dynamic> expenseFormat = [
        expense.name,
        expense.amount,
        expense.dateTime,
      ];

      allExpenseFormat.add(expenseFormat);
      myBox.put("All_Expenses", allExpenseFormat);
    }
  }

  //save all data to hive
  List<ExpenseItems> readData() {
    List savedExpenses = myBox.get("All_Expenses") ?? [];
    List<ExpenseItems> allExpense = [];
    for (var i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      ExpenseItems expense =
          ExpenseItems(name: name, amount: amount, dateTime: dateTime);
      allExpense.add(expense);
    }
    return allExpense;
  }

/*
listing the incomes
*/
  void saveIncomeList(List<double> incomeList) {
    List<double> listedIncome = [];
    for (var i = 0; i < incomeList.length; i++) {
      listedIncome.add(incomeList[i]);
    }
    myBox.put("Listed_Income", listedIncome);
  }

  List<double> readIncomeList() {
    List<double> listedIncome = myBox.get("Listed_Income") ?? [];
    return listedIncome;
  }

/*
listing expense
*/
  void saveExpenseList(List<double> expenseList) {
    List<double> listedExpense = [];
    for (var i = 0; i < expenseList.length; i++) {
      listedExpense.add(expenseList[i]);
    }
    myBox.put("Listed_expense", listedExpense);
  }

  List<double> readExpenseList() {
    List<double> listedExpese = myBox.get("Listed_expense") ?? [];
    return listedExpese;
  }

// save income value on hive
  void saveIncomeValue(List<double> incomeList) {
    myBox.put("IncomeValue", incomeList[incomeList.length - 1].toInt());
  }

// read income value from hive
  int readIncomeValue() {
    int incomeValue = myBox.get("IncomeValue") ?? 0;
    return incomeValue;
  }

  //save expense value to hive
  void saveExpenseValues(List<double> expenseList) {
    myBox.put("ExpenseValue", expenseList[expenseList.length - 1].toInt());
  }

  // read expense value from hime
  int readExpenseValue() {
    int expenseValue = myBox.get("ExpenseValue");
    return expenseValue;
  }

//save income list total
  void saveTotalIncome(List<double> incomeList) {
    int totalIncome = 0;
    saveIncomeList(incomeList);
    List<double> test = readIncomeList();
    for (var i = 0; i < test.length; i++) {
      totalIncome += test[i].toInt();
    }
    myBox.put("Total_Income", totalIncome);
  }

//read total income list
  int readTotalIncome() {
    int totalIncome = myBox.get("Total_Income") ?? 0;
    return totalIncome;
  }

  //save income list total
  void saveTotalExpense(List<double> expenseList) {
    int totalExpense = 0;
    saveExpenseList(expenseList);
    List<double> test = readExpenseList();
    for (var i = 0; i < test.length; i++) {
      totalExpense += test[i].toInt();
    }
    myBox.put("Total_Expense", totalExpense);
  }

//read total income list
  int readTotalExpense() {
    int totalExpense = myBox.get("Total_Expense") ?? 0;
    return totalExpense;
  }

  //save total balance to hive
  void saveTotalBalance(List<double> incomeList, List<double> expenseList) {
    int totalBalance = 0;
    saveTotalIncome(incomeList);
    saveTotalExpense(expenseList);
    totalBalance = readTotalIncome() - readTotalExpense();
    myBox.put("Total_balance", totalBalance);
  }

  // read total balance from hive
  int readTotalBalance() {
    int totalBalance = myBox.get("Total_balance") ?? 0;
    return totalBalance;
  }
}
