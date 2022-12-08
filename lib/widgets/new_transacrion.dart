// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:personal_expenses_app/widgets/adaptive_button.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  const NewTransaction(this.addTx, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedtDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enterTitle = _titleController.text;
    final enterAmount = double.parse(_amountController.text);

    if (enterTitle.isEmpty || enterAmount <= 0 || _selectedtDate == null) {
      return;
    }
    widget.addTx(enterTitle, enterAmount, _selectedtDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      initialDate: DateTime.now(),
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then(
      (pickeDate) {
        if (pickeDate == null) {}
        setState(() {
          _selectedtDate = pickeDate as DateTime;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isIos = UniversalPlatform.isIOS;
    bool isWeb = UniversalPlatform.isWeb;
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                onSubmitted: (_) => _submitData(),
              ),
              SizedBox(
                height: 70,
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedtDate == null
                            ? 'No date choose!'
                            : DateFormat.yMd().format(_selectedtDate!),
                      ),
                      AdaptiveButton("Chosen Date:", _presentDatePicker),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 224, 222, 222),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
