import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/common_widgets/bottom_navigationbar.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/add_product_body.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/edit_product_body.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {

  String productId;
  EditProductScreen({required this.productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appbar,
      body: EditProductBody(productId: widget.productId, horizontalSize: MediaQuery.of(context).size.width,),
      bottomNavigationBar: bottomNavigationBar(context, index),
    );
  }
}
