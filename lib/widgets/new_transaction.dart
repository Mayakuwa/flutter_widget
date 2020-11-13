import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:personal_expence_app/widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {

  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitDate() {

    if(_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if(enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate
    );

    //これを追加するとキーボードのreturnを押したとき自動でwidgetが閉じる
    Navigator.of(context).pop();
  }

  //カレンダー形式で日にちをpickしてくれる
  void _presentDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now()
    ).then((pickedData) {
      if(pickedData == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedData;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10, 
              left: 10, 
              right: 10, 
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitDate()
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                  //これは特殊な書き方
                  onSubmitted: (_) => _submitDate(),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                    Expanded(
                      child: Text(
                          _selectedDate == null ?
                          'No data Chosen!' :
                          'Picked Date : ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker)
                  ],),
                ),
                RaisedButton(
                  child: Text('Add Transaction'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                  onPressed: _submitDate,
                )
              ]),
        ),
      ),
    );
  }
}
