// ignore_for_file: prefer_const_constructors
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses_app/widgets/chart.dart';
import 'package:personal_expenses_app/widgets/new_transacrion.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';
import 'package:device_preview/device_preview.dart';
import 'models/transaction.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isIos = UniversalPlatform.isIOS;
    bool isWeb = UniversalPlatform.isWeb;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _usertransaction = [];
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final txNew = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );
    setState(() {
      _usertransaction.add(txNew);
      // print(txNew);
    });
  }

  List<Transaction> get _recentTransactions {
    return _usertransaction.where((item) {
      return item.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: (() {}),
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _usertransaction.removeWhere((item) => item.id == id);
    });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    // Currently, if you include the dart.io.
    // Platform anywhere in your code, your app will throw the following error on Web:
    bool isIos = UniversalPlatform.isIOS;
    bool isWeb = UniversalPlatform.isWeb;
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final dynamic appBar = (isIos || isWeb)
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.add,
                    size: 20,
                  ),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            elevation: 0,
            title: Text(
              'Personal Expenses',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add),
              )
            ],
          );
    final txListWidgets = SizedBox(
      height: (size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          .7,
      child: TransactionList(
        _usertransaction,
        deleteItem: _deleteTransaction,
      ),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Show chart: ",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Switch.adaptive(
                    activeColor: Theme.of(context).primaryColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  )
                ],
              ),
            if (!isLandscape)
              SizedBox(
                height: (size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    .3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txListWidgets,
            if (isLandscape)
              _showChart
                  ? SizedBox(
                      height: (size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          .7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidgets
          ],
        ),
      ),
    );
    if ((isIos || isWeb)) {
      return CupertinoPageScaffold(
        navigationBar: appBar,
        child: pageBody,
      );
    } else {
      return Scaffold(
        appBar: appBar,
        body: pageBody,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (isIos || isWeb)
            ? Text("This IOS")
            : FloatingActionButton(
                onPressed: () => _startAddNewTransaction(context),
                child: Icon(Icons.add),
              ),
      );
    }
  }
}
