import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/affiliate/data/models/transactions.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliate_transactions/transactions_bloc.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliate_transactions/transactions_event.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliate_transactions/transactions_state.dart';
import 'package:cash_admin_app/features/affiliate/presentation/widgets/transaction_detail_box.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/loading_box.dart';
import 'package:cash_admin_app/features/common_widgets/no_data_box.dart';
import 'package:cash_admin_app/features/common_widgets/search_widget.dart';
import 'package:cash_admin_app/features/common_widgets/something_went_wrong_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionsBody extends StatefulWidget {

  String userId;
  TransactionsBody({required this.userId});

  @override
  State<TransactionsBody> createState() => _TransactionsBodyState();
}

class _TransactionsBodyState extends State<TransactionsBody> {

  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool _isFirstLoadRunning = false;

  late ScrollController _allTransactionsController;
  late ScrollController scrollController;
  List<Transactions> _allTransactions = [];
  List fetchedTransactions = [];
  int _allTransactionsIndex = 0;
  int _skip = 9;

  void loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _allTransactionsController.position.extentAfter < 300
    ) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _allTransactionsIndex += 1;
      final skipNumber = _allTransactionsIndex * _skip;
      final transactions = BlocProvider.of<AffiliateTransactionsBloc>(context);
      transactions.add(GetMoreAffiliateTransactionsEvent(widget.userId, skipNumber));
      if (fetchedTransactions.isNotEmpty) {
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

    final transactions = BlocProvider.of<AffiliateTransactionsBloc>(context);
    transactions.add(GetAffiliateTransactionsEvent(widget.userId, 0));

  }

  @override
  void initState() {
    _firstLoad();
    _allTransactionsController = ScrollController()..addListener(loadMore);
    scrollController = ScrollController()..addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        loadMore();
      }});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AffiliateTransactionsBloc, AffiliateTransactionsState>(builder: (_, state){
      if(state is GetAffiliateTransactionsSuccessfulState){
        return _allTransactions.isEmpty
            ? Center(child: noDataBox(text: "No Transactions!", description: "Transactions will appear here."))
            : transactionByBody();
      } else if(state is GetAffiliateTransactionsLoadingState){
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(child: loadingBox()));
      } else if(state is GetAffiliateTransactionsFailedState) {
        return errorBox(onPressed: (){
          final transactions = BlocProvider.of<AffiliateTransactionsBloc>(context);
          transactions.add(GetAffiliateTransactionsEvent(widget.userId, 0));
        });
      } else{
        return _isFirstLoadRunning
            ? const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        )
            :  Center(child: Text(""),);
      }
    }, listener: (_, state){
      if(state is GetAffiliateTransactionsSuccessfulState){
        setState(() {
          _isFirstLoadRunning = false;
        });
        _allTransactions.addAll(state.transactions);
        fetchedTransactions = state.transactions;
      }
    });
  }

  Widget transactionByBody() {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        height: MediaQuery.of(context).size.width < 1100 ? null : MediaQuery.of(context).size.height - desktopHeaderheight,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: surfaceColor, width: 1.0),
            left: BorderSide(color: surfaceColor, width: 1.0),
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Row(
              children: [
                Text(
                  "Transactions by ",
                  style: TextStyle(
                    color: onBackgroundColor,
                    fontSize: 20,),
                ),
                Flexible(
                  child: Text(
                    _allTransactions[0].affiliate.fullName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: onBackgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Divider(color: onBackgroundColor, thickness: 1.0,),
            SizedBox(height: 10,),
            ListView.builder(
                controller: _allTransactionsController,
                shrinkWrap: true,
                itemCount: _allTransactions.length,
                itemBuilder: (context, index){
                  return transactionByDetailBox(transaction: _allTransactions[index]);
                }),
            if (_isLoadMoreRunning == true)
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(color: primaryColor,),
                ),
              ),
          ],
        ),
      ),
    );
  }

}