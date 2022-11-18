import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/common_widgets/bottom_navigationbar.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/add_product_body.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

  int index = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appbar,
      body: AddProductBody(horizontalSize: MediaQuery.of(context).size.width,),
      bottomNavigationBar: bottomNavigationBar(context, index),
    );
  }
}
