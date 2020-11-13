import 'package:flutter/material.dart';
import 'package:personal_expence_app/model/transaction.dart';
import 'package:intl/intl.dart';


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
          SizedBox(
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
              Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8
                ),
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text('\$${transactions[index].amount}')),
                      ),
                    ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460 ?
                  FlatButton.icon(
                      onPressed: () => deleteTx(transactions[index].id),
                      icon: Icon(Icons.delete),
                      label: Text('Delete'),
                      textColor: Theme.of(context).errorColor,
                  )
                  : IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () => deleteTx(transactions[index].id),
                  ),
                ),
              );
          },
          itemCount: transactions.length,
      );
  }
}
