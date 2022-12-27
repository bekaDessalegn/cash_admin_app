import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/loading_box.dart';
import 'package:cash_admin_app/features/common_widgets/no_data_box.dart';
import 'package:cash_admin_app/features/common_widgets/not_connected.dart';
import 'package:cash_admin_app/features/common_widgets/product_list_box.dart';
import 'package:cash_admin_app/features/common_widgets/search_widget.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:cash_admin_app/features/products/data/models/categories.dart';
import 'package:cash_admin_app/features/products/data/models/local_products.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';
import 'package:cash_admin_app/features/products/data/models/selectedCategory.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_state.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_state.dart';
import 'package:cash_admin_app/features/products/presentation/widgets/local_product_list_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mi.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProductsBody extends StatefulWidget {
  double horizontalPadding;

  ProductsBody({required this.horizontalPadding});

  @override
  State<ProductsBody> createState() => _ProductsBodyState(horizontalPadding);
}

class _ProductsBodyState extends State<ProductsBody> with TickerProviderStateMixin {
  double horizontalPadding;

  _ProductsBodyState(this.horizontalPadding);

  String? value;
  List<String> filter = ["Latest", "Old"];

  final categoryScrollController = ItemScrollController();
  final categoryItemListener = ItemPositionsListener.create();
  int categoryItemPosition = 0;
  int categoryLast = 0;

  List<Categories> categoryList = [Categories(categoryName: "All products")];
  int selectedCategoryIndex = 0;

  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool _isFirstLoadRunning = false;

  late ScrollController _allProductsController;
  late ScrollController scrollController;
  // List<Products> _allProducts = [];
  List fetchedProducts = [];
  int _allProductsIndex = 0;
  int _skip = 9;

  bool isCategoryLoading = false;

  final productSearchController = TextEditingController();

  List<List<Products>> productsList = [[]];

  void loadMore() async {
    print("The fetched products");
    print(fetchedProducts.length);
    print(_allProductsIndex);
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _allProductsController.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _allProductsIndex += 1;
      final skipNumber = _allProductsIndex * _skip;
      final moreProducts = BlocProvider.of<ProductsBloc>(context);

      if (categoryList[selectedCategoryIndex].categoryName == "All products") {
        moreProducts.add(GetProductsForListEvent(skipNumber));
      } else {
        moreProducts.add(FilterMoreProductsByCategoryEvent(
            categoryList[selectedCategoryIndex].categoryName, skipNumber));
      }

      if (fetchedProducts.isNotEmpty) {
        setState(() {});
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    productsList[selectedCategoryIndex] = [];
    _hasNextPage = true;
    _allProductsIndex = 0;
    final firstProductsLoad = BlocProvider.of<ProductsBloc>(context);
    firstProductsLoad.add(GetProductsForListEvent(0));

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  @override
  void initState() {
    _firstLoad();
    _allProductsController = ScrollController()..addListener(loadMore);
    scrollController = ScrollController()..addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        loadMore();
      }});
    categoryListener();
    final categories = BlocProvider.of<CategoriesBloc>(context);
    categories.add(GetCategoriesEvent());
    selectedCategoryIndex = 0;
    categoryList = [Categories(categoryName: "All products")];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SelectedCategory>(context, listen: false).selectedIndex(0);
    });
    productsList=[[]];
    super.initState();
  }

  @override
  void dispose() {
    productSearchController.dispose();
    super.dispose();
  }

  void categoryListener() {
    categoryItemListener.itemPositions.addListener(() {
      final indices = categoryItemListener.itemPositions.value
          .where((element) {
            final isRightVisible = element.itemLeadingEdge >= 0;
            final isLeftVisible = element.itemTrailingEdge <= 1;

            return isRightVisible && isLeftVisible;
          })
          .map((e) => e.index)
          .toList();

      setState(() {
        categoryLast = indices.last;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected,
          child: internetNotAvailable(context: context, message: "No Internet Connection!!!"),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      semiBoldText(
                          value: "Products",
                          size: mobileHeaderFontSize,
                          color: onBackgroundColor),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: (){
                                context.push(APP_PAGE.categories.toPath);
                              },
                              child: Text("Categories", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       context.go(APP_PAGE.categories.toPath);
                      //     },
                      //     child: Text("Categories"))
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: productSearchController,
                          onChanged: (value) {
                            final searchProducts =
                            BlocProvider.of<SearchProductBloc>(context);
                            searchProducts.add(SearchProductEvent(value));
                          },
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: onBackgroundColor),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            filled: true,
                            fillColor: surfaceColor,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none
                            ),
                            hintText: "Search....",
                            hintStyle: TextStyle(
                                color: textInputPlaceholderColor
                            ),
                            prefixIcon: Icon(Icons.search),
                            prefixIconColor: textInputPlaceholderColor,
                          ),
                        ),
                      ),
                      // Container(
                      //   width: 40,
                      //   margin: EdgeInsets.only(right: 10),
                      //   child: DropdownButtonHideUnderline(
                      //     child: DropdownButton<String>(
                      //       icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
                      //       // value: values,
                      //       isExpanded: true,
                      //       hint: Iconify(Mi.filter, size: 40, color: onBackgroundColor,),
                      //       items: filter.map(buildMenuLocation).toList(),
                      //       onChanged: (value) => setState(() {
                      //         this.value = value;
                      //         print(value);
                      //       }),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  // Container(
                  //   child: Row(
                  //     children: [
                  //       IconButton(
                  //         icon: Icon(Icons.arrow_back_ios),
                  //         onPressed: () {
                  //           if (_tabController.index > 0) {
                  //             _tabController.animateTo(_tabController.index - 1);
                  //           } else {
                  //             // Scaffold.of(context).showSnackBar(SnackBar(
                  //             //   content: Text("Can't go back"),
                  //             // ));
                  //           }
                  //         },
                  //       ),
                  //       Expanded(
                  //         child: TabBar(
                  //             isScrollable: true,
                  //             controller: _tabController,
                  //             labelStyle: TextStyle(color: Colors.black),
                  //             unselectedLabelColor: Colors.black,
                  //             labelColor: Colors.blue,
                  //             tabs: tabs
                  //         ),
                  //       ),
                  //       IconButton(
                  //         icon: Icon(Icons.arrow_forward_ios),
                  //         onPressed: () {
                  //           if (_tabController.index + 1 < tabs.length) {
                  //             _tabController.animateTo(_tabController.index + 1);
                  //           } else {
                  //             // Scaffold.of(context).showSnackBar(SnackBar(
                  //             //   content: Text("Can't move forward"),
                  //             // ));
                  //           }
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  BlocConsumer<SearchProductBloc, SearchState>(builder: (_, state) {
                    if (state is SearchProductSuccessful) {
                      if (productSearchController.text.isEmpty) {
                        return buildInitialInput();
                      }
                      return searchedProducts(products: state.product);
                    } else if(state is SearchProductSocketErrorState){
                      return localSearchedProducts(products: state.localProducts);
                    } else if (state is SearchProductLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    } else {
                      return buildInitialInput();
                    }
                  }, listener: (_, state) {
                    if (state is SearchProductFailed) {
                      buildErrorLayout(context: context, message: state.errorType);
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInitialInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        Row(
          children: [
            categoryItemPosition == 0
                ? SizedBox()
                : MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        categoryItemPosition -= 1;
                      });
                      categoryScrollController.scrollTo(
                          index: categoryItemPosition,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Icon(
                      Icons.navigate_before_sharp,
                      color: primaryColor,
                    ))),
            Expanded(
              child: BlocConsumer<CategoriesBloc, CategoriesState>(
                  builder: (_, state) {
                    if (state is GetCategoriesSuccessful) {
                      return buildCategories();
                    } else {
                      return buildCategories();
                    }
                  },
                  listener: (_, state) {
                    if(state is GetCategoriesSuccessful){

                      setState(() {
                        categoryList.addAll(state.categories);
                        for(var productCategories in state.categories){
                          productsList.add([]);
                        }
                        print(productsList);
                      });
                    }
                  }),
            ),
            categoryLast == categoryList.length - 1
                ? SizedBox()
                : MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        categoryItemPosition += 1;
                      });
                      categoryScrollController.scrollTo(
                          index: categoryItemPosition,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Icon(
                      Icons.navigate_next_sharp,
                      color: primaryColor,
                    ))),
          ],
        ),
        SizedBox(height: 5,),
        Divider(
          color: surfaceColor, thickness: 1.0,
        ),
        SizedBox(
          height: 10,
        ),
        BlocConsumer<ProductsBloc, ProductsState>(
          listener: (_, state){
            if(state is GetProductsSuccessful){
              productsList[selectedCategoryIndex].addAll(state.products);
              // _allProducts.addAll(state.products);
              // _allProducts.addAll(productsList[selectedCategoryIndex]!);
              fetchedProducts = state.products;
              isCategoryLoading = false;
              setState(() {
                _isLoadMoreRunning = false;
              });
            } else if(state is GetProductsLoading){
              isCategoryLoading = true;
              print(productsList.toString() == "[[]]");
              print(productsList);
              if(productsList.toString() != "[[]]"){
                setState(() {
                  _isLoadMoreRunning = true;
                });
              }
            }
          },
          builder: (_, state) {
            if (state is GetProductsFailed) {
              return Center(
                child: errorBox(onPressed: (){
                  final categories = BlocProvider.of<CategoriesBloc>(context);
                  categories.add(GetCategoriesEvent());
                  final products =
                  BlocProvider.of<ProductsBloc>(context);
                  products.add(GetProductsForListEvent(0));
                }),
              );
            } else if(state is GetProductsLoading){
              if(productsList.toString() == "[[]]"){
                return Center(child: loadingBox(),);
              } else {
                return productListView();
              }
            }
            else if (state is GetProductsSuccessful) {
              return productsList[selectedCategoryIndex].isEmpty
                  ? Center(child: noDataBox(text: "No Products!", description: "Products will appear here."))
                  : productListView();
            } else if(state is SocketErrorState){
              return localProductListView(localProducts: state.localProducts);
            } else {
              return Center(child: Text(""),);
            }
          },
        ),
      ],
    );
  }

  Widget productListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            controller: _allProductsController,
            itemCount: productsList[selectedCategoryIndex].length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
                return productListBox(context: context, products: productsList[selectedCategoryIndex][index],);
            }),
        if (_isLoadMoreRunning == true)
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 40),
            child: Center(
              child: CircularProgressIndicator(color: primaryColor,),
            ),
          ),
      ],
    );
  }

  Widget localProductListView({required List<LocalProducts> localProducts}) {
    return ListView.builder(
        itemCount: localProducts.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return localProductListBox(context: context, products: localProducts[index],);
        });
  }

  Widget searchedProducts({required List<Products> products}) {
    return products.isEmpty ? Center(child: noDataBox(text: "No result found!", description: "please try another name.")) : ListView.builder(
        itemCount: products.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
            return productListBox(context: context, products: products[index],);
        });
  }

  Widget localSearchedProducts({required List<LocalProducts> products}) {
    return products.isEmpty ? Center(child: noDataBox(text: "No result found!", description: "please try another name.")) : ListView.builder(
        itemCount: products.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return localProductListBox(context: context, products: products[index],);
        });
  }

  Widget buildCategories() {
    return SizedBox(
      height: 32,
      child: ScrollablePositionedList.builder(
          itemScrollController: categoryScrollController,
          itemPositionsListener: categoryItemListener,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            return Consumer<SelectedCategory>(
              builder: (context, data, child) => MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if(!isCategoryLoading){
                      productsList[selectedCategoryIndex] = [];
                      _hasNextPage = true;
                      _allProductsIndex = 0;
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                      data.selectedIndex(index);
                      final filterProductsByCategory = BlocProvider.of<ProductsBloc>(context);
                      if(categoryList[index].categoryName == "All products"){
                        filterProductsByCategory.add(GetProductsForListEvent(0));
                      }
                      else{
                        filterProductsByCategory.add(FilterProductsByCategoryEvent(categoryList[index].categoryName, 0));
                      }
                    }
                  },
                  child: Container(
                    height: 32,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: data.index == index
                            ? primaryColor
                            : backgroundColor,
                        border: Border.all(color: primaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(20)),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          categoryList[index].categoryName,
                          style: TextStyle(
                              fontSize: 16,
                              color: data.index == index
                                  ? onPrimaryColor
                                  : onBackgroundColor),
                        )),
                  ),
                ),
              ),
            );
          }),
    );
  }

  DropdownMenuItem<String> buildMenuLocation(String filter) => DropdownMenuItem(
    value: filter,
    child: Text(
      filter,
      style: TextStyle(
        color: onBackgroundColor,
        fontSize: 14,
      ),
    ),
  );
}
