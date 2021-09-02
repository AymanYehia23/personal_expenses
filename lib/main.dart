import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';

import 'model/transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',

        textTheme: ThemeData.light().textTheme.copyWith(
        headline5: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
            button: TextStyle(color: Colors.white),
        ),

        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
            )
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   final List<Transaction> _userTransactions = [
  //   Transaction(
  //       id: 't1', title: 'New shoes', amount: 68.36, date: DateTime.now()),
  //   Transaction(
  //       id: 't2', title: 'New T-shirt', amount: 44.67, date: DateTime.now())
   ];

   List<Transaction> get _recentTransaction{
     return _userTransactions.where((tx){
       return tx.date.isAfter(
         DateTime.now().subtract(Duration(days: 7))
       );
     }).toList();
   }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date:chosenDate
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return NewTransaction(_addNewTransaction);
    });
  }

  void _deleteTransaction(String id){
     setState(() {
       _userTransactions.removeWhere((tx){
         return tx.id == id;
       });
     });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: ()=> _startAddNewTransaction(context),
        )
      ],
    );

    return Scaffold(
      appBar:appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height - appBar.preferredSize.height
              - MediaQuery.of(context).padding.top)*0.3,
                child: Chart(_recentTransaction)
            ),
            Container(
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height
                    - MediaQuery.of(context).padding.top)*0.7,
                child: TransactionList(_userTransactions,_deleteTransaction)
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=> _startAddNewTransaction(context),
      ),
    );
  }
}
