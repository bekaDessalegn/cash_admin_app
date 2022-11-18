import 'package:cash_admin_app/features/affiliate/presentation/widgets/transaction_by_body.dart';
import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class TransactionByScreen extends StatelessWidget {
  String userId;
  TransactionByScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: TransactionsBody(userId: userId,),
    );
  }
}
