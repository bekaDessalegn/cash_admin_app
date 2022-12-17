import 'dart:convert';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/bold_text.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/list_image.dart';
import 'package:cash_admin_app/features/common_widgets/loading_box.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/socket_error_widget.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_state.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/delete_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:intl/intl.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class ProductDetailsBody extends StatefulWidget {
  String? productId;
  double imageSize;

  ProductDetailsBody({required this.productId, required this.imageSize});

  @override
  State<ProductDetailsBody> createState() =>
      _ProductDetailsBodyState(productId, imageSize);
}

class _ProductDetailsBodyState extends State<ProductDetailsBody> {
  double imageSize;
  String? productId;

  _ProductDetailsBodyState(this.productId, this.imageSize);

  int? isPublished, isFeatured, isTopSeller;

  var productDescriptionController = quill.QuillController.basic();
  var emptyController = quill.QuillController.basic();

  @override
  void initState() {
    final productDetails = BlocProvider.of<SingleProductBloc>(context);
    productDetails.add(GetSingleProductEvent(productId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingleProductBloc, SingleProductState>(
        listener: (_, state){
          if(state is GetSingleProductSuccessful){
            var productDescriptionJSON = jsonDecode(state.product.description!);
            productDescriptionController = quill.QuillController(
                document: quill.Document.fromJson(productDescriptionJSON),
                selection: TextSelection.collapsed(offset: 0));
          }
        },
        builder: (_, state) {
      if (state is GetSingleProductSuccessful) {
        return buildInitialInput(product: state.product);
      } else if(state is GetSingleProductSocketError){
        return Center(child: socketErrorWidget(onPressed: (){
          final productDetails = BlocProvider.of<SingleProductBloc>(context);
          productDetails.add(GetSingleProductEvent(productId!));
        }),);
      } else if (state is GetSingleProductFailed) {
        return errorBox(onPressed: () {
          final productDetails = BlocProvider.of<SingleProductBloc>(context);
          productDetails.add(GetSingleProductEvent(productId!));
        });
      } else if (state is GetSingleProductLoading) {
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(child: loadingBox()));
      } else {
        return Center(child: Text(""));
      }
    });
  }

  Widget buildInitialInput({required Products product}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                "${DateFormat("dd/MM/yyyy").format(
                  DateTime.parse("${product.createdAt}"),
                )}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: onBackgroundColor,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            product.mainImage!.path == "null"
                ? Container(
                    width: double.infinity,
                    height: imageSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      image: DecorationImage(
                          image: AssetImage("images/default.png"),
                          fit: BoxFit.cover),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ProgressiveImage(
                      placeholder: AssetImage('images/loading.png'),
                      thumbnail:
                          NetworkImage("$baseUrl${product.mainImage!.path}"),
                      image: NetworkImage("$baseUrl${product.mainImage!.path}"),
                      height: 172,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${product.productName}",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                color: onBackgroundColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price",
                      style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${product.price} ETB",
                      style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Commission",
                      style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${product.commission} ETB",
                      style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: surfaceColor,
              thickness: 1.0,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    "Categories",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  child: Text(
                    product.categories!.join(", "),
                    style: TextStyle(
                      color: onBackgroundColor,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: surfaceColor,
              thickness: 1.0,
            ),
            SizedBox(height: 0, child: quill.QuillEditor.basic(controller: emptyController, readOnly: true),),
            product.description == json.encode([{"insert":"\n"}])
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      quill.QuillEditor.basic(controller: productDescriptionController, readOnly: true),
                      Divider(
                        color: surfaceColor,
                        thickness: 1.0,
                      ),
                    ],
                  ),
            SizedBox(
              height: 10,
            ),
            product.moreImages!.length == 0
                ? SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Images",
                        style: TextStyle(
                            color: onBackgroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                            itemCount: product.moreImages!.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Image.network(
                                              "$baseUrl${product.moreImages![index]['path']}",
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: listImage(
                                        urlImage:
                                            "$baseUrl${product.moreImages![index]['path']}"),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Divider(
                        color: surfaceColor,
                        thickness: 1.0,
                      ),
                    ],
                  ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Published",
                  style: TextStyle(
                      color: onBackgroundColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                product.published!
                    ? Iconify(
                        Ic.baseline_radio_button_checked,
                        size: 18,
                        color: primaryColor,
                      )
                    : Iconify(
                        Ic.baseline_radio_button_unchecked,
                        size: 18,
                        color: onBackgroundColor,
                      )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Featured",
                  style: TextStyle(
                      color: onBackgroundColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                product.featured!
                    ? Iconify(
                        Ic.baseline_radio_button_checked,
                        size: 18,
                        color: primaryColor,
                      )
                    : Iconify(
                        Ic.baseline_radio_button_unchecked,
                        size: 18,
                        color: onBackgroundColor,
                      ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Sellers",
                  style: TextStyle(
                      color: onBackgroundColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                product.topSeller!
                    ? Iconify(
                        Ic.baseline_radio_button_checked,
                        size: 18,
                        color: primaryColor,
                      )
                    : Iconify(
                        Ic.baseline_radio_button_unchecked,
                        size: 18,
                        color: onBackgroundColor,
                      ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: surfaceColor,
              thickness: 1.0,
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  context.goNamed(
                    APP_PAGE.editProduct.toName,
                    params: {'product_id': product.productId!},
                  );
                },
                child: boldText(
                    value: "Edit product", size: 15, color: linkColor)),
            SizedBox(
              height: 10,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return deleteProductDialog(
                            context: context,
                            productId: product.productId,
                          );
                        });
                  },
                  child: boldText(
                      value: "Delete product", size: 15, color: dangerColor)),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              color: surfaceColor,
              thickness: 1.0,
            )
          ],
        ),
      ),
    );
  }
}
