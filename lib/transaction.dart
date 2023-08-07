import 'package:flutter/material.dart';

class Trans extends StatelessWidget {
  final String transactioname;
  final String money;
  final String expenseOrIncome;

  Trans({
    required this.transactioname,
    required this.money,
    required this.expenseOrIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.all(15),
          color:
              expenseOrIncome == 'expense' ? Colors.red[50] : Colors.green[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue[900]),
                    child: Center(
                      child: Icon(
                        Icons.currency_rupee,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(transactioname,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.blue[900],
                      )),
                ],
              ),
              Text(
                (expenseOrIncome == 'expense' ? '-' : '+') + 'Rs.' + money,
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 16, fontWeight: FontWeight.w600,
                  color:
                      expenseOrIncome == 'expense' ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
