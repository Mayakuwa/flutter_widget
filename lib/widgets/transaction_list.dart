import 'package:flutter/material.dart';
import 'package:personal_expence_app/model/transaction.dart';
import 'transaction_item.dart';


class TransactionList extends StatelessWidget {

  TransactionList(this.transactions, this.deleteTx);

  final List<Transaction> transactions;
  final Function deleteTx;
  
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty ? LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          Text(
            'No transaction exit',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.cover),
          ),
        ],
      );
    }):
    ListView.builder(
          itemBuilder: (ctx, index) {
            return
              new TransactionItem(
                  transaction: transactions[index],
                  deleteTx: deleteTx);
          },
          itemCount: transactions.length,
      );
  }
}

