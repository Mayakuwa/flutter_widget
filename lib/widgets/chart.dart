import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expence_app/model/transaction.dart';
import 'package:personal_expence_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groundTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index), );

      double totalSum  = 0.0;

      for(var i = 0; i < recentTransactions.length; i++) {
        if(recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      print(DateFormat.E().format(weekDay));
      print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum};
    }).reversed.toList();
  }

  double get totalSpending {
    return groundTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groundTransactionValues);
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groundTransactionValues.map((date) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  date['day'],
                  date['amount'],
                  totalSpending == 0.0 ? 0.0 : (date['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
