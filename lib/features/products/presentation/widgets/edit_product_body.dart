import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/normal_textformfield.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:cash_admin_app/features/products/data/models/product_image.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_state.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_state.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/commission_rate_textformfield.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/description_textformfield.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/number_textformfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:multiselect/multiselect.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditProductBody extends StatefulWidget {
  double horizontalSize;
  String productId;

  EditProductBody({required this.productId, required this.horizontalSize});

  @override
  State<EditProductBody> createState() => _EditProductBodyState(productId, horizontalSize);
}

class _EditProductBodyState extends State<EditProductBody> {
  double horizontalSize;
  String productId;

  late Products product;

  _EditProductBodyState(this.productId, this.horizontalSize);

  int index = 1;

  String? categoryType;

  final _addProductFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController commissionController = TextEditingController();
  var descriptionController = quill.QuillController.basic();
  var emptyController = quill.QuillController.basic();

  String? contentType;
  List imageType = [];
  List listImageType = [];
  List<String> selectedCategories = [];

  int? publishedSelectedValue;
  int? featuredSelectedValue;
  int? topSellerSelectedValue;

  File? _pickedImage;
  Uint8List selectedWebImage = Uint8List(8);

  List<XFile>? imageFileList = [];
  List<Uint8List> selectedListImages = [];
  final ImagePicker imagePicker = ImagePicker();

  int commissionRate = 0;

  Future getCommissionRateValue() async {
    await getCommissionRate().then((value) {
      setState(() {
        commissionRate = value;
      });
    });
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        var selectedImage = await selected.readAsBytes();
        setState(() {
          _pickedImage = selected;
          selectedWebImage = selectedImage;
          contentType = lookupMimeType(image.path);
        });
      } else {
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedWebImage = webImage;
          _pickedImage = selected;
          contentType = image.mimeType;
        });
      } else {
        print("No image has been picked");
      }
    } else {
      print("Something went wrong");
    }
  }

  Future<void> _pickListImages() async {
    if (!kIsWeb) {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        selectedImages.map((e) => imageFileList!.add(e));
        for (var images in selectedImages) {
          var webImage = await images.readAsBytes();
          selectedListImages.add(webImage);
          List type = lookupMimeType(images.path)!.split("/");
          listImageType.add(type);
        }
      }
      setState(() {
      });
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        for (var images in selectedImages) {
          var webImage = await images.readAsBytes();
          setState(() {
            selectedListImages.add(webImage);
            print(images.mimeType);
            List type = images.mimeType!.split("/");
            print("Type");
            print(type);
            listImageType.add(type);
            print("Some");
            print(listImageType);
          });
        }
      } else {
        print("No image has been picked");
      }
    } else {
      print("Something went wrong");
    }
  }

  // Future mainImage() async {
  //   Uint8List bytes = (await NetworkAssetBundle(Uri.parse("$baseUrl${product.mainImage!.path}"))
  //       .load("$baseUrl${product.mainImage!.path}"))
  //       .buffer
  //       .asUint8List();
  //
  //   print("Byte image");
  //   print(bytes);
  // }

  @override
  void initState() {
    getCommissionRateValue();
    product = Products.fromJson(jsonDecode(productId));
    print(product.productName);
    // mainImage();
    setState(() {
      nameController.text = product.productName;
      priceController.text = product.price.toString();
      commissionController.text = product.commission.toString();
      var descriptionJSON = jsonDecode(product.description!);
      descriptionController = quill.QuillController(
          document: quill.Document.fromJson(descriptionJSON),
          selection: TextSelection.collapsed(offset: 0));
      for (var categories in product.categories!){
        selectedCategories.add(categories.toString());
      }
      product.published! ? publishedSelectedValue = 1 : publishedSelectedValue = 0;
      product.featured! ? featuredSelectedValue = 1 : featuredSelectedValue = 0;
      product.topSeller! ? topSellerSelectedValue = 1 : topSellerSelectedValue = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(listener: (_, state) {
      if (state is PostProductsFailed) {
        buildErrorLayout(context: context, message: state.errorType);
      } else if (state is PostProductsSuccessful) {
        final firstProductsLoad = BlocProvider.of<ProductsBloc>(context);
        firstProductsLoad.add(GetProductsForListEvent(0));
        final productDetails = BlocProvider.of<SingleProductBloc>(context);
        productDetails.add(GetSingleProductEvent(product.productId!));
        context.goNamed(APP_PAGE.productDetails.toName, params: {'product_id': product.productId!},);
      }
    }, builder: (_, state) {
      if (state is PostProductsLoading) {
        return buildInitialInput(isLoading: true);
      } else {
        return buildInitialInput(isLoading: false);
      }
    });
  }

  Widget buildInitialInput({required bool isLoading}) => Center(
    child: SizedBox(
      width: horizontalSize,
      child: Form(
        key: _addProductFormKey,
        child: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                semiBoldText(
                    value: "Edit Product",
                    size: 28,
                    color: onBackgroundColor),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: addProductVerticalSpacing,
                    ),
                    normalTextFormField(
                        type: "Name",
                        hint: "Product name",
                        controller: nameController),
                    SizedBox(
                      height: addProductVerticalSpacing,
                    ),
                    semiBoldText(
                        value: "Category",
                        size: defaultFontSize,
                        color: onBackgroundColor),
                    const SizedBox(
                      height: smallSpacing,
                    ),
                    BlocConsumer<CategoriesBloc, CategoriesState>(
                        listener: (_, state) {
                          if (state is GetCategoriesFailed) {
                            buildErrorLayout(
                                context: context,
                                message:
                                "Couldn't load categories, Please try again");
                          }
                        }, builder: (_, state) {
                      if (state is GetCategoriesSuccessful) {
                        List<String> categories = [];
                        for (var category in state.categories) {
                          categories.add(category.categoryName);
                        }
                        return DropDownMultiSelect(
                          options: categories,
                          whenEmpty: 'Select a category',
                          onChanged: (value) {
                            setState(() {
                              selectedCategories = value;
                            });
                          },
                          selectedValues: selectedCategories,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      } else if (state is GetCategoriesLoading) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: textInputBorderColor)),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                )),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(""),
                        );
                      }
                    }),
                    SizedBox(
                      height: addProductVerticalSpacing,
                    ),
                    semiBoldText(value: "Description", size: defaultFontSize, color: onBackgroundColor),
                    SizedBox(
                      height: 0,
                      child: quill.QuillEditor.basic(
                          controller: emptyController, readOnly: true),
                    ),
                    SizedBox(height: smallSpacing,),
                    quill.QuillToolbar.basic(
                      controller: descriptionController,
                      toolbarIconSize: 17,
                      showFontFamily: false,
                      showSearchButton: false,
                      showRedo: false,
                      showUndo: false,
                      showHeaderStyle: false,
                      showDirection: false,
                      showQuote: false,
                      showCodeBlock: false,
                      showIndent: true,
                      showStrikeThrough: false,
                      showListCheck: false,
                      showBackgroundColorButton: false,
                      showDividers: false,
                      showInlineCode: false,
                      showLink: false,
                      showClearFormat: false,
                    ),
                    Container(
                        height: 300,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(defaultRadius),
                            border: Border.all(color: textInputBorderColor)
                        ),
                        child: quill.QuillEditor.basic(controller: descriptionController, readOnly: false)),
                    SizedBox(
                      height: addProductVerticalSpacing,
                    ),
                    Row(
                      children: [
                        // Expanded(
                        //     child: numberTextFormField(
                        //         type: "Price",
                        //         hint: "Price",
                        //         controller: priceController)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              semiBoldText(value: "Price", size: defaultFontSize, color: onBackgroundColor),
                              const SizedBox(height: smallSpacing,),
                              TextFormField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value){
                                  print("The value is $value");
                                  print(value.toString());
                                  if(value.isNotEmpty){
                                    int _commissionPrice = ((int.parse(value) * commissionRate)/100).floor();
                                    setState(() {
                                      commissionController.text = _commissionPrice.toString();
                                    });
                                  }
                                },
                                validator: (value){
                                  if(value!.isEmpty){
                                    return "Value can not be empty";
                                  } else if(int.parse(value) < 0){
                                    return "Value must be positive";
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: "Price",
                                  hintStyle: TextStyle(color: textInputPlaceholderColor),
                                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: textInputBorderColor),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(defaultRadius),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: dangerColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        // Expanded(
                        //     child: commissionRateTextFormField(
                        //         type: "Commission",
                        //         hint: "Commission",
                        //         controller: commissionController)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              semiBoldText(value: "Commission", size: defaultFontSize, color: onBackgroundColor),
                              const SizedBox(height: smallSpacing,),
                              TextFormField(
                                controller: commissionController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value){
                                  if(value!.isEmpty){
                                    return "Value can not be empty";
                                  } else{
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: "Commission",
                                  hintStyle: TextStyle(color: textInputPlaceholderColor),
                                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: textInputBorderColor),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(defaultRadius),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: dangerColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: addProductVerticalSpacing,
                    ),
                    semiBoldText(
                        value: "Main Image",
                        size: defaultFontSize,
                        color: onBackgroundColor),
                    SizedBox(
                      height: 10,
                    ),
                    selectedWebImage.toString() != "[0, 0, 0, 0, 0, 0, 0, 0]" ?
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Stack(
                              children: [
                                Image.memory(selectedWebImage, width: 120, height: 120, fit: BoxFit.cover,),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: 120,
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              selectedWebImage = Uint8List(8);
                                            });
                                          },
                                          child: Iconify(MaterialSymbols.delete_outline, color: dangerColor,)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    )
                        : product.mainImage?.path == "null" ? SizedBox() : Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Image.network("$baseUrl${product.mainImage!.path}", width: 120, height: 120, fit: BoxFit.cover,),
                        ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              _pickImage();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                padding:
                                EdgeInsets.symmetric(vertical: 10)),
                            child: Iconify(
                              Bi.upload,
                              color: onPrimaryColor,
                              size: 20,
                            ))),
                    SizedBox(
                      height: addProductVerticalSpacing,
                    ),
                    semiBoldText(
                        value: "More Images",
                        size: defaultFontSize,
                        color: onBackgroundColor),
                    SizedBox(
                      height: 10,
                    ),
                    selectedListImages.isNotEmpty ?
                    GridView.builder(
                        itemCount: selectedListImages.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, mainAxisExtent: 120),
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    Image.memory(selectedListImages[index], width: double.infinity, height: 120, fit: BoxFit.cover,),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  setState(() {
                                                    selectedListImages.removeAt(index);
                                                  });
                                                });
                                              },
                                              child: Iconify(MaterialSymbols.delete_outline, color: dangerColor,)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        })
                        : product.moreImages!.isEmpty ? SizedBox() : GridView.builder(
                        itemCount: product.moreImages!.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, mainAxisExtent: 120),
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network("$baseUrl${product.moreImages![index]["path"]}", width: double.infinity, height: 120, fit: BoxFit.cover,)),
                          );
                        }),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              _pickListImages();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                padding:
                                EdgeInsets.symmetric(vertical: 10)),
                            child: Iconify(
                              Bi.upload,
                              color: onPrimaryColor,
                              size: 20,
                            ))),
                    SizedBox(
                      height: addProductVerticalSpacing,
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
                        SizedBox(
                          width: 18,
                          child: RadioListTile(
                              value: 1,
                              groupValue: publishedSelectedValue,
                              activeColor: primaryColor,
                              toggleable: true,
                              onChanged: (value) {
                                setState(() {
                                  publishedSelectedValue = value;
                                });
                              }),
                        ),
                      ],
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
                        SizedBox(
                          width: 18,
                          child: RadioListTile(
                              value: 1,
                              groupValue: featuredSelectedValue,
                              activeColor: primaryColor,
                              toggleable: true,
                              onChanged: (value) {
                                setState(() {
                                  featuredSelectedValue = value;
                                });
                              }),
                        ),
                      ],
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
                        SizedBox(
                          width: 18,
                          child: RadioListTile(
                              value: 1,
                              groupValue: topSellerSelectedValue,
                              activeColor: primaryColor,
                              toggleable: true,
                              onChanged: (value) {
                                setState(() {
                                  topSellerSelectedValue = value;
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () async {
                          if (_addProductFormKey.currentState!
                              .validate()) {
                            // print("File");
                            // print(_pickedImage!.path);
                            // print("Somesing");
                            // print(_pickedImage);
                            // print(
                            //     "Main WEB Image : ${selectedWebImage}");
                            // print(
                            //     "More LIST OF WEB Images : ${selectedListImages}");
                            // print("Main Mobile Images : ${_pickedImage}");
                            // print(
                            //     "More LIST OF Mobile Images : ${imageFileList!.length}");
                            // print(nameController.text);
                            // print(categoryController.text);
                            // print(descriptionController.text);
                            // print(priceController.text);
                            // print(commissionController.text);
                            // print(selectedWebImage.toString());
                            // print(json.encode(descriptionController.text));
                            // descriptionController.text.isEmpty
                            //     ? print("It is null")
                            //     : print("It is not null");
                            // print(contentType);
                            if(contentType.toString() != "null"){
                              List type = contentType!.split("/");
                              imageType = type;
                            }
                            print(imageType);
                            final productDesc = jsonEncode(descriptionController.document.toDelta().toJson());
                            final products =
                            BlocProvider.of<ProductsBloc>(context);
                            products.add(PatchProductEvent(Products(
                              productId: product.productId,
                                productName: nameController.text,
                                description: productDesc,
                                mainImage: ProductImage(path: selectedWebImage.toString()),
                                moreImages: selectedListImages,
                                price: double.parse(priceController.text),
                                categories: selectedCategories,
                                commission:
                                double.parse(commissionController.text),
                                published: publishedSelectedValue == 1
                                    ? true
                                    : false,
                                featured: featuredSelectedValue == 1
                                    ? true
                                    : false,
                                topSeller: topSellerSelectedValue == 1
                                    ? true
                                    : false), imageType, listImageType));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            disabledBackgroundColor: disabledPrimaryColor,
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: onPrimaryColor,
                          ),
                        )
                            : normalText(
                            value: "Save",
                            size: 20,
                            color: onPrimaryColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );

  DropdownMenuItem<String> buildCategoryList(String category) =>
      DropdownMenuItem(
        value: category,
        child: Text(
          category,
          style: TextStyle(
            color: onBackgroundColor,
            fontSize: 16,
          ),
        ),
      );
}
