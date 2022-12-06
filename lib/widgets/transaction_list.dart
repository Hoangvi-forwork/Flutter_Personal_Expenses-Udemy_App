import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteItem;
  const TransactionList(this.transactions,
      {super.key, required this.deleteItem});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: transactions.isEmpty
          ? Column(
              // ignore: prefer_const_literals_to_create_immutables
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/icons/empty-box.png',
                        fit: BoxFit.cover),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: const Text(
                      'No transaction added yet!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              height: 550,
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: ((context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: FittedBox(
                          child: Text('\$${transactions[index].amount}'),
                        ),
                      ),
                      title: Text(
                        transactions[index].title,
                        style: const TextStyle(
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat.yMMMMd().format(transactions[index].date),
                      ),
                      trailing: IconButton(
                        onPressed: () => deleteItem(transactions[index].id),
                        icon: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
