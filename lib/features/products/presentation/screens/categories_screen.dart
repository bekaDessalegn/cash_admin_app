import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/services/app_service.dart';
import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/loading_box.dart';
import 'package:cash_admin_app/features/common_widgets/no_data_box.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:cash_admin_app/features/common_widgets/socket_error_widget.dart';
import 'package:cash_admin_app/features/products/data/models/categories.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_state.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/add_category_dialog.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/delete_category_dialog.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/edit_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  @override
  void initState() {
    final categories =
    BlocProvider.of<CategoriesBloc>(context);
    categories.add(GetCategoriesEvent());
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (_, state) {
              if (state is GetCategoriesFailed) {
                return errorBox(onPressed: (){
                  final categories =
                  BlocProvider.of<CategoriesBloc>(context);
                  categories.add(GetCategoriesEvent());
                });
              } else if (state is GetCategoriesSuccessful) {
                return buildInitialInput(categories: state.categories);
              } else if(state is GetCategoriesSocketErrorState){
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(child: socketErrorWidget(onPressed: (){
                    final categories = BlocProvider.of<CategoriesBloc>(context);
                    categories.add(GetCategoriesEvent());
                  }),),
                );
              } else if (state is GetCategoriesLoading) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: loadingBox()));
              } else {
                return Center(
                  child: Text(""),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildInitialInput({required List<Categories> categories}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              semiBoldText(
                  value: "Categories", size: 25, color: onBackgroundColor),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return addCategoryDialog(context: context);
                        });
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: primaryColor,
                    size: 25,
                  ))
            ],
          ),
          SizedBox(height: 10,),
          Divider(color: onBackgroundColor, thickness: 1.0,),
          SizedBox(height: 10,),
          categories.isEmpty
              ? Center(child: noDataBox(text: "No Categories!", description: "Categories will appear here."))
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: Text(
                                categories[index].categoryName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // MouseRegion(
                                    //   cursor: SystemMouseCursors.click,
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       showDialog(
                                    //           context: context,
                                    //           builder: (BuildContext context) {
                                    //             return editCategoryDialog(
                                    //                 context: context,
                                    //                 categoryId:
                                    //                     categories[index]
                                    //                         .categoryId,
                                    //                 categoryName:
                                    //                     categories[index]
                                    //                         .categoryName);
                                    //           });
                                    //     },
                                    //     child: Text(
                                    //       "Edit",
                                    //       style: TextStyle(
                                    //           decoration:
                                    //               TextDecoration.underline,
                                    //           color: primaryColor,
                                    //           fontSize: 16),
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                    // Text(
                                    //   "|",
                                    //   style: TextStyle(
                                    //       decoration: TextDecoration.underline,
                                    //       color: primaryColor,
                                    //       fontSize: 16),
                                    // ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return deleteCategoryDialog(
                                                    context: context,
                                                    categoryId:
                                                        categories[index]
                                                            .categoryId,
                                                    categoryName:
                                                        categories[index]
                                                            .categoryName);
                                              });
                                        },
                                        child: Iconify(Ic.round_delete, color: dangerColor, size: 25,),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: surfaceColor,
                            thickness: 1.0,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    );
                  })
        ],
      ),
    );
  }
}
