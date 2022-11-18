import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/common_widgets/bottom_navigationbar.dart';
import 'package:cash_admin_app/features/common_widgets/product_list_box.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/products_body.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appbar,
      body: ProductsBody(horizontalPadding: 0),
      bottomNavigationBar: bottomNavigationBar(context, index),
    );
  }
}
