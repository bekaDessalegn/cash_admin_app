import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/loading_box.dart';
import 'package:cash_admin_app/features/common_widgets/no_data_box.dart';
import 'package:cash_admin_app/features/common_widgets/orders_list_box.dart';
import 'package:cash_admin_app/features/common_widgets/search_widget.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:cash_admin_app/features/common_widgets/something_went_wrong_error_widget.dart';
import 'package:cash_admin_app/features/orders/data/models/local_order.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_bloc.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_event.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_state.dart';
import 'package:cash_admin_app/features/orders/presentation/widgets/local_orders_list_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mi.dart';

class OrdersBody extends StatefulWidget {
  const OrdersBody({Key? key}) : super(key: key);

  @override
  State<OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> {

  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool _isFirstLoadRunning = false;

  late ScrollController _allOrdersController;
  late ScrollController scrollController;
  List<Orders> _allOrders = [];
  List fetchedOrders = [];
  int _allOrdersIndex = 0;
  int _skip = 9;

  String? value;
  List<String> filter = ["Pending", "Accepted", "Rejected"];
  final orderSearchController = TextEditingController();

  void loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _allOrdersController.position.extentAfter < 300
    ) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _allOrdersIndex += 1;
      final skipNumber = _allOrdersIndex * _skip;
      if(value == "Pending"){
        final orders = BlocProvider.of<OrdersBloc>(context);
        orders.add(MoreFilterPendingEvent(skipNumber));
      } else if(value == "Accepted"){
        final orders = BlocProvider.of<OrdersBloc>(context);
        orders.add(MoreFilterAcceptedEvent(skipNumber));
      } else if(value == "Rejected"){
        final orders = BlocProvider.of<OrdersBloc>(context);
        orders.add(MoreFilterRejectedEvent(skipNumber));
      } else{
        final orders = BlocProvider.of<OrdersBloc>(context);
        orders.add(GetMoreOrdersEvent(skipNumber));
      }
      if (fetchedOrders.isNotEmpty) {
        setState(() {

        });
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

    final orders =
    BlocProvider.of<OrdersBloc>(context);
    orders.add(GetOrdersEvent(0));

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  @override
  void initState() {
    _allOrders = [];
    _firstLoad();
    _allOrdersController = ScrollController()..addListener(loadMore);
    scrollController = ScrollController()..addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        loadMore();
      }});
    super.initState();
  }

  @override
  void dispose() {
    orderSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            semiBoldText(
                value: "Orders",
                size: mobileHeaderFontSize,
                color: onBackgroundColor),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: orderSearchController,
                    onChanged: (value) {
                      final searchOrders = BlocProvider.of<SearchOrderBloc>(context);
                      searchOrders.add(SearchOrdersEvent(value, value));
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
                SizedBox(
                  width: 100,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
                      // value: values,
                      isExpanded: true,
                      hint: Iconify(Mi.filter, size: 40, color: onBackgroundColor,),
                      items: filter.map(buildMenuLocation).toList(),
                      onChanged: (value) => setState(() {
                        _allOrders = [];
                        if(value == "Pending"){
                          final orders = BlocProvider.of<OrdersBloc>(context);
                          orders.add(FilterPendingEvent(0));
                        } else if(value == "Accepted"){
                          final orders = BlocProvider.of<OrdersBloc>(context);
                          orders.add(FilterAcceptedEvent(0));
                        } else if(value == "Rejected"){
                          final orders = BlocProvider.of<OrdersBloc>(context);
                          orders.add(FilterRejectedEvent(0));
                        }
                        this.value = value;
                      }),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Divider(
              color: surfaceColor, thickness: 1.0,
            ),
            BlocConsumer<SearchOrderBloc, SearchState>(builder: (_, state) {
              if (state is SearchOrderSuccessful) {
                if (orderSearchController.text.isEmpty) {
                  return buildInitialInput();
                }
                return searchedOrders(orders: state.order);
              } else if (state is SearchOrderLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else {
                return buildInitialInput();
              }
            }, listener: (_, state) {
              if (state is SearchOrderFailed) {
                buildErrorLayout(context: context, message: state.errorType);
              }
            }),
          ],
        ),
      ),
    );
  }
  Widget buildInitialInput(){
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (_, state){
        if(state is GetOrdersSuccessfulState){
          _allOrders.addAll(state.orders);
          fetchedOrders = state.orders;
        }
      },
      builder: (_, state) {
        if (state is GetOrdersFailedState) {
          return Center(
            child: errorBox(onPressed: (){
              final orders =
              BlocProvider.of<OrdersBloc>(context);
              orders.add(GetOrdersEvent(0));
            }),
          );
        } else if(state is GetOrdersLoadingState){
          return Center(child: loadingBox(),);
        }
        else if (state is GetOrdersSuccessfulState) {
          return _allOrders.isEmpty
              ? Center(child: noDataBox(text: "No Orders!", description: "Orders will appear here."))
              : ordersListView();
        } else if (state is GetOrderSocketErrorState){
          return localOrdersView(localOrder: state.localOrder);
        } else {
          return Center(child: Text(""),);
        }
      },
    );
  }

  Widget ordersListView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            controller: _allOrdersController,
            shrinkWrap: true,
            itemCount: _allOrders.length,
            itemBuilder: (context, index) {
                return ordersListBox(context: context, order: _allOrders[index]);
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

  Widget localOrdersView({required List<LocalOrder> localOrder}){
    return ListView.builder(
        shrinkWrap: true,
        itemCount: localOrder.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return localOrdersListBox(context: context, order: localOrder[index]);
        });
  }

  Widget searchedOrders({required List<Orders> orders}){
    return orders.isEmpty ? Center(child: noDataBox(text: "No Orders!", description: "There are no orders based on your search")) : ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (context, index) {
            return ordersListBox(context: context, order: orders[index]);
        });
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
