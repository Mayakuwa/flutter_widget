import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:personal_expence_app/widgets/chart.dart';
import 'package:personal_expence_app/widgets/new_transaction.dart';
import 'package:personal_expence_app/widgets/transaction_list.dart';
import 'model/transaction.dart';

void main()  {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
          subtitle1: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  // String titleInput;
  // String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //transactionオブジェクトから生成
  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7)
        )
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(context: ctx, builder: (_) {
      return
        GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery,
      PreferredSizeWidget appBar,
      Widget txListWidget) {
    return [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
            'Show Chart',
            style: Theme.of(context).textTheme.title),
        Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            })
      ],
    ), _showChart ?
    Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
        child: Chart(_recentTransactions))
        : txListWidget];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery,
      PreferredSizeWidget appBar,
      Widget txListWidget
      ) {
    return [Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height - mediaQuery.padding.top) * 0.3,
        child: Chart(_recentTransactions),
    ), txListWidget];
  }

  PreferredSizeWidget appBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => _startAddNewTransaction(context),
            )
          ]),
    ) : AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context)
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final txListWidget = Container(
        height: (mediaQuery.size.height -
            appBar().preferredSize.height) * 0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape) ..._buildLandscapeContent(mediaQuery, appBar(), txListWidget),
          if(!isLandscape) ..._buildPortraitContent(mediaQuery, appBar(), txListWidget),
        ],),
    ));

    return Platform.isIOS
      ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar())
      : Scaffold(
      appBar: appBar(),
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ?
          Container()
      : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {

        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
