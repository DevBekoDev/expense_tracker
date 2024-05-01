import 'dart:math';
import 'package:expense_tracker/components/expense_summery.dart';
import 'package:expense_tracker/components/list_tiles.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpenseItem() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("New Expense"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                    ),
                    controller: newExpenseNameController,
                  ),
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
                    controller: newExpenseAmountController,
                  ),
                ],
              ),
              actions: [
                MaterialButton(onPressed: save, child: const Text('Save')),
                MaterialButton(onPressed: cancel, child: const Text('Cancel'))
              ],
            ));
  }

  void save() {
    if (newExpenseAmountController.text.isNotEmpty &&
        newExpenseNameController.text.isNotEmpty) {
      ExpenseItems newExpense = ExpenseItems(
          name: newExpenseNameController.text,
          amount: newExpenseAmountController.text,
          dateTime: DateTime.now());
      Provider.of<ExpenseData>(context, listen: false).addNewItem(newExpense);
    }
    Navigator.pop(context);
    clearForm();
  }

  void cancel() {
    Navigator.pop(context);
    clearForm();
  }

  void clearForm() {
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
            extendBody: true,
            //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            body: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              children: [
                Expensummary(startOftheWeek: value.startOfChart()),
                const SizedBox(
                  height: 20,
                ),
                check(value, context),
              ],
            )));
  }
}

Widget check(ExpenseData test, context) {
  if (test.expenseList.isEmpty) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: const Text(
          "No Money were Spent!!!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  } else {
    return ListView.builder(
        shrinkWrap: true,
        reverse: true,
        scrollDirection: Axis.vertical,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: test.getALLItemsList().length,
        itemBuilder: (context, index) => ExpenseTiles(
            name: test.getALLItemsList()[index].name,
            amount: test.getALLItemsList()[index].amount,
            date: test.getALLItemsList()[index].dateTime));
  }
}
