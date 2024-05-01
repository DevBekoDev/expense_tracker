import 'package:flutter/material.dart';

class ExpenseTiles extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime date;
  const ExpenseTiles(
      {super.key,
      required this.name,
      required this.amount,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey)),
            child: ListTile(
              title: Text(
                name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${date.day}/${date.month}/${date.year}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '\$$amount',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
