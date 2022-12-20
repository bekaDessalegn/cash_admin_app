import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/bold_text.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/no_data_widget.dart';
import 'package:cash_admin_app/features/common_widgets/normal_button.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/not_connected.dart';
import 'package:cash_admin_app/features/common_widgets/success_flashbar.dart';
import 'package:cash_admin_app/features/home/data/models/analytics.dart';
import 'package:cash_admin_app/features/home/presentation/blocs/home_bloc.dart';
import 'package:cash_admin_app/features/home/presentation/blocs/home_event.dart';
import 'package:cash_admin_app/features/home/presentation/blocs/home_state.dart';
import 'package:cash_admin_app/features/home/presentation/widgets/featured_products_box.dart';
import 'package:cash_admin_app/features/home/presentation/widgets/local_featured_products_box.dart';
import 'package:cash_admin_app/features/home/presentation/widgets/local_unanswered_order_box.dart';
import 'package:cash_admin_app/features/home/presentation/widgets/mobile_dashboard_box.dart';
import 'package:cash_admin_app/features/home/presentation/widgets/unanswered_orders_box.dart';
import 'package:cash_admin_app/features/orders/data/models/local_order.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:cash_admin_app/features/products/data/models/local_products.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/majesticons.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  String email = "";

  final updateWhoAreWeWebContentFormKey = GlobalKey<FormState>();
  final updateHowToAffiliateWithUsWebContentFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    getEmail();
    // final admin = BlocProvider.of<ProfileBloc>(context);
    // admin.add(LoadAdminEvent());
    final featuredProducts = BlocProvider.of<FilterFeaturedBloc>(context);
    featuredProducts.add(FilterFeaturedProductsEvent());
    final topSellerProducts = BlocProvider.of<FilterTopSellerBloc>(context);
    topSellerProducts.add(FilterTopSellerProductsEvent());
    final unAnsweredProducts = BlocProvider.of<FilterUnAnsweredBloc>(context);
    unAnsweredProducts.add(FilterUnAnsweredProductsEvent());
    final analytics = BlocProvider.of<AnalyticsBloc>(context);
    analytics.add(GetAnalyticsEvent());

    super.initState();
  }

  Future getEmail() async {
    await getEmailData().then((value) {
      setState(() {
        email = value;
        print(email);
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
            child: Column(
              children: [
                email == "Null"
                    ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  color: surfaceColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email has not been set",
                        style: TextStyle(color: onBackgroundColor),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            context.go(APP_PAGE.addEmail.toPath);
                          },
                          child: Text(
                            "Add Email",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: primaryColor),
                          ),
                        ),
                      )
                    ],
                  ),
                )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 0, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocConsumer<AnalyticsBloc, AnalyticsState>(builder: (_, state){
                        if(state is GetAnalyticsSuccessfulState){
                          return analytics(analytics: state.analytics);
                        } else if(state is GetAnalyticsLoadingState){
                          return loadingAnalytics();
                        } else if(state is GetAnalyticsFailedState){
                          return errorBox(onPressed: (){
                            final analytics = BlocProvider.of<AnalyticsBloc>(context);
                            analytics.add(GetAnalyticsEvent());
                          });
                        } else{
                          return Center(child: Text(""),);
                        }
                      }, listener: (_, state){

                      }),
                      SizedBox(
                        height: 40,
                      ),
                      boldText(
                          value: "Unanswered orders",
                          size: mobileh1,
                          color: onBackgroundColor),
                      SizedBox(height: 10,),
                      BlocBuilder<FilterUnAnsweredBloc, FilterUnAnsweredState>(builder: (_, state){
                        if(state is FilterUnAnsweredSuccessful){
                          return state.orders.isEmpty ?
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: noDataWidget(message: "Unanswered orders will appear here", icon: Majesticons.clipboard_list_line),
                          ) :
                          unAnsweredListView(orders: state.orders);
                        } else if (state is FilterUnAnsweredSocketErrorState){
                          return localUnAnsweredListView(orders: state.localOrder);
                        } else if(state is FilterUnAnsweredLoading){
                          return loadingUnAnswered();
                        } else if(state is FilterUnAnsweredFailed){
                          return errorBox(onPressed: (){
                            final unAnswered = BlocProvider.of<FilterUnAnsweredBloc>(context);
                            unAnswered.add(FilterUnAnsweredProductsEvent());
                          });
                        } else{
                          return SizedBox();
                        }
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      boldText(
                          value: "Featured products",
                          size: mobileh1,
                          color: onBackgroundColor),
                      SizedBox(height: 10,),
                      BlocBuilder<FilterFeaturedBloc, FilterFeaturedState>(builder: (_, state){
                        if(state is FilterFeaturedSuccessful){
                          return state.products.isEmpty ? Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: noDataWidget(message: "Featured products will appear here", icon: Bi.pin_angle),
                          ) : featuredListView(products: state.products);
                        } else if (state is FilterFeaturedSocketErrorState){
                          return localFeaturedListView(products: state.localProducts);
                        } else if(state is FilterFeaturedLoading){
                          return loadingFeatured();
                        } else if(state is FilterFeaturedFailed){
                          return errorBox(onPressed: (){
                            final topSeller = BlocProvider.of<FilterFeaturedBloc>(context);
                            topSeller.add(FilterFeaturedProductsEvent());
                          });
                        } else{
                          return SizedBox();
                        }
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      boldText(
                          value: "Top Sellers",
                          size: mobileh1,
                          color: onBackgroundColor),
                      SizedBox(height: 10,),
                      BlocBuilder<FilterTopSellerBloc, FilterTopSellerState>(builder: (_, state){
                        if(state is FilterTopSellerSuccessful){
                          return state.products.isEmpty ? Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: noDataWidget(message: "Top seller products will appear here", icon: Ph.package),
                          ) : topSellerListView(products: state.products);
                        } else if (state is FilterTopSellerSocketErrorState){
                          return localTopSellerListView(products: state.localProducts);
                        } else if(state is FilterTopSellerLoading){
                          return loadingFeatured();
                        } else if(state is FilterTopSellerFailed){
                          return errorBox(onPressed: (){
                            final topSeller = BlocProvider.of<FilterTopSellerBloc>(context);
                            topSeller.add(FilterTopSellerProductsEvent());
                          });
                        } else{
                          return SizedBox();
                        }
                      }),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget featuredListView({required List<Products> products}){
    return SizedBox(
      height: 255,
      child: ListView.builder(
          itemCount: products.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return featuredProductsBox(context: context, product: products[index]);
          }),
    );
  }

  Widget localFeaturedListView({required List<LocalProducts> products}){
    return SizedBox(
      height: 255,
      child: ListView.builder(
          itemCount: products.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return localFeaturedProductsBox(context: context, product: products[index]);
          }),
    );
  }

  Widget topSellerListView({required List<Products> products}){
    return SizedBox(
      height: 255,
      child: ListView.builder(
          itemCount: products.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return featuredProductsBox(context: context, product: products[index]);
          }),
    );
  }

  Widget localTopSellerListView({required List<LocalProducts> products}){
    return SizedBox(
      height: 255,
      child: ListView.builder(
          itemCount: products.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return localFeaturedProductsBox(context: context, product: products[index]);
          }),
    );
  }

  Widget unAnsweredListView({required List<Orders> orders}){
    return SizedBox(
      height: 285,
      child: ListView.builder(
          itemCount: orders.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return unAnsweredOrdersBox(context: context, order: orders[index]);
          }),
    );
  }

  Widget localUnAnsweredListView({required List<LocalOrder> orders}){
    return SizedBox(
      height: 285,
      child: ListView.builder(
          itemCount: orders.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return localUnAnsweredOrdersBox(context: context, order: orders[index]);
          }),
    );
  }

  String numberFormat(int n) {
    String num = n.toString();
    int len = num.length;

    if (n >= 1000 && n < 1000000) {
      return num.substring(0, len - 3) + '.' + num.substring(len - 3, 1 + (len - 3)) + 'K';
    } else if (n >= 1000000 && n < 1000000000) {
      return num.substring(0, len - 6) + '.' + num.substring(len - 6, 1 + (len - 6)) + 'M';
    } else if (n > 1000000000) {
      return num.substring(0, len - 9) + '.' + num.substring(len - 9, 1 + (len - 9)) + 'B';
    } else {
      return num.toString();
    }
  }

  Widget analytics({required Analytics analytics}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            boldText(value: "Overview", size: mobileh1, color: onBackgroundColor),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: (){
                      showDialog(context: context, builder: (BuildContext context){
                        return Dialog(child: Container(
                          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                          child: MediaQuery.of(context).size.width < 500 ?
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("General Overview", style: TextStyle(fontWeight: FontWeight.w900),),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.close)),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Divider(color: onBackgroundColor.withOpacity(0.8), thickness: 1.0,),
                                SizedBox(height: 10,),
                                Text("Total Products", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("${analytics.totalProducts}"),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Text("Total Affiliates", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("${analytics.totalAffiliates}"),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Text("Accepted Orders", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("${analytics.acceptedOrders}"),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Text("Total Orders", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("${analytics.totalOrders}"),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Text("Total Expended", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("${analytics.totalEarned}"),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Text("Total Unpaid", style: TextStyle(fontWeight: FontWeight.bold),),
                                Text("${analytics.totalUnpaid}"),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ) :
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("General Overview", style: TextStyle(fontWeight: FontWeight.w900),),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.close)),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Divider(color: onBackgroundColor.withOpacity(0.8), thickness: 1.0,),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Products"),
                                    Text("${analytics.totalProducts}")
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Affiliates"),
                                    Text("${analytics.totalAffiliates}")
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Accepted Orders"),
                                    Text("${analytics.acceptedOrders}")
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Orders"),
                                    Text("${analytics.totalOrders}")
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Expended"),
                                    Text("${analytics.totalEarned}")
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Unpaid"),
                                    Text("${analytics.totalUnpaid}")
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Divider(color: surfaceColor, thickness: 1.0,),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),);
                      });
                    },
                    child: Iconify(Teenyicons.expand_alt_solid, size: mobileh1, color: onBackgroundColor)),
              ),
            )
          ],
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Row(
            children: [
              Expanded(
                  child: mobileDashboardBox(
                      value: "${numberFormat(analytics.totalProducts.toInt())}", type: "Products")),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: mobileDashboardBox(
                      value: "${numberFormat(analytics.totalAffiliates.toInt())}", type: "Affiliates")),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Row(
            children: [
              Expanded(
                  child: mobileDashboardBox(
                      value: "${numberFormat(analytics.acceptedOrders.toInt())}/${numberFormat(analytics.totalOrders.toInt())}", type: "Orders")),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: mobileDashboardBox(
                      value: "${numberFormat(analytics.totalEarned.toInt())}", type: "Expended")),
            ],
          ),
        ),
      ],
    );
  }

  Widget loadingAnalytics(){
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          boldText(value: "Overview", size: mobileh1, color: onBackgroundColor),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: Container(
                height: 113,
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: surfaceColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(defaultRadius)
                ),
              )),
              SizedBox(width: 10,),
              Expanded(child: Container(
                height: 113,
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: surfaceColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(defaultRadius)
                ),
              ))
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: Container(
                height: 113,
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: surfaceColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(defaultRadius)
                ),
              )),
              SizedBox(width: 10,),
              Expanded(child: Container(
                height: 113,
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    color: surfaceColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(defaultRadius)
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }

  Widget loadingUnAnswered(){
    return SizedBox(
      height: 285,
      child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              width: 250,
              height: 295,
              margin: EdgeInsets.fromLTRB(0, 10, 50, 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 2.0,
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget loadingFeatured(){
    return SizedBox(
      height: 255,
      child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              width: 250,
              height: 295,
              margin: EdgeInsets.fromLTRB(0, 10, 50, 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 2.0,
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

}
