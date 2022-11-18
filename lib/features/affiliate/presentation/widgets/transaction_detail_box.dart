import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/affiliate/data/models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget transactionByDetailBox({required Transactions transaction}){
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Id ",
            style: TextStyle(
              color: onBackgroundColor,
              fontSize: 16,),
          ),
          Flexible(
            child: Text(
              "${transaction.transactionId}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: onBackgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      SizedBox(height: 5,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Date ",
            style: TextStyle(
              color: onBackgroundColor,
              fontSize: 16,),
          ),
          Flexible(
            child: Text(
              "${DateFormat("dd/MM/yyyy").format(
                DateTime.parse("${transaction.transactedAt}"),
              )}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: onBackgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      SizedBox(height: 5,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Type ",
            style: TextStyle(
              color: onBackgroundColor,
              fontSize: 16,),
          ),
          Flexible(
            child: Text(
              "${transaction.reason.kind}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: onBackgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      SizedBox(height: 5,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Amount ",
            style: TextStyle(
              color: onBackgroundColor,
              fontSize: 16,),
          ),
          Flexible(
            child: Text(
              "${transaction.amount} ETB",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: onBackgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Divider(color: surfaceColor, thickness: 1.0,),
      SizedBox(height: 10,),
    ],
  );
}