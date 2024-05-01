import 'dart:math';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final newIncomeNameController = TextEditingController();
  final newIncomeAmountController = TextEditingController();
  void addNewExpenseItem() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("New Income"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Amount',
                    ),
                    controller: newIncomeAmountController,
                  ),
                ],
              ),
              actions: [
                MaterialButton(onPressed: save, child: const Text('Save')),
                MaterialButton(onPressed: cancel, child: const Text('Cancel'))
              ],
            ));
  }

  double money = 0;
  void save() {
    if (newIncomeAmountController.text.isNotEmpty) {
      double newExpense = double.parse(newIncomeAmountController.text);
      Provider.of<ExpenseData>(context, listen: false).addNewIncome(newExpense);
    }
    Navigator.pop(context);
    clearForm();
  }

  void cancel() {
    Navigator.pop(context);
    clearForm();
  }

  void clearForm() {
    newIncomeAmountController.clear();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                floatingActionButton: FloatingActionButton(
                  onPressed: addNewExpenseItem,
                  shape: const CircleBorder(),
                  child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [Colors.black, Colors.grey],
                              transform: GradientRotation(pi / 4))),
                      child: const Icon(
                        CupertinoIcons.add,
                        color: Colors.white70,
                      )),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                                colors: [Colors.black, Colors.grey],
                                transform: GradientRotation(pi / 4)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Total Balance',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "\$${value.db.readData().isNotEmpty ? value.db.readTotalBalance() : 0}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w400)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: const BoxDecoration(
                                              color: Colors.white30,
                                              shape: BoxShape.circle),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_upward,
                                              color: Colors.greenAccent,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Income',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                                "\$${value.db.readData().isNotEmpty ? value.db.readIncomeValue() : 0}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: const BoxDecoration(
                                              color: Colors.white30,
                                              shape: BoxShape.circle),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_downward,
                                              color: Colors.redAccent,
                                              size: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Expense',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                                "\$${value.db.readData().isNotEmpty ? value.db.readExpenseValue() : 0}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600))
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        memePicker(value, context)
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}

Widget memePicker(ExpenseData test, context) {
  if (test.db.readTotalIncome() == 0) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.height / 2,
          child: SizedBox.fromSize(
            size: const Size.fromRadius(48),
            child: Image.asset(
              'assests/img/getYourMoneyupppp.gif',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  } else if (test.db.readTotalExpense() <= test.db.readTotalIncome() / 2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.height / 2,
          child: SizedBox.fromSize(
            size: const Size.fromRadius(48),
            child: Image.asset(
              'assests/img/rich.jpg',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  } else if (test.db.readTotalExpense() > test.db.readTotalIncome() / 2 &&
      test.db.readTotalBalance() >= 0) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.height / 2,
          child: SizedBox.fromSize(
            size: const Size.fromRadius(48),
            child: Image.asset(
              'assests/img/broke.jpg',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  } else if (test.db.readTotalExpense() >= test.db.readTotalIncome() ||
      test.db.readTotalBalance() < 0) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.height / 2,
          child: SizedBox.fromSize(
            size: const Size.fromRadius(48),
            child: Image.asset(
              'assests/img/error.jpg',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.height / 2,
          child: SizedBox.fromSize(
            size: const Size.fromRadius(48),
            child: Image.asset(
              'assests/img/error.jpg',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
