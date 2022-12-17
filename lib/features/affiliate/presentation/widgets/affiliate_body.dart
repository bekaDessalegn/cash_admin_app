import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/affiliate/data/models/affiliates.dart';
import 'package:cash_admin_app/features/affiliate/data/models/local_affiliate.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_bloc.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_event.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_state.dart';
import 'package:cash_admin_app/features/affiliate/presentation/widgets/local_affiliate_list_box.dart';
import 'package:cash_admin_app/features/common_widgets/affiliate_list_box.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/loading_box.dart';
import 'package:cash_admin_app/features/common_widgets/no_data_box.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mi.dart';

class AffiliatesBody extends StatefulWidget {
  const AffiliatesBody({Key? key}) : super(key: key);

  @override
  State<AffiliatesBody> createState() => _AffiliatesBodyState();
}

class _AffiliatesBodyState extends State<AffiliatesBody> {

  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  bool _isFirstLoadRunning = false;

  late ScrollController _allAffiliatesController;
  late ScrollController scrollController;
  List<Affiliates> _allAffiliates = [];
  List fetchedAffiliates = [];
  int _allAffiliatesIndex = 0;
  int _skip = 9;

  String? value;
  List<String> filter = ["Date", "Earnings up", "Earnings down", "Most parents"];
  final affiliateSearchController = TextEditingController();

  void loadMore() async {
    if (_hasNextPage == true &&
        _isLoadMoreRunning == false &&
        _allAffiliatesController.position.extentAfter < 300
    ) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _allAffiliatesIndex += 1;
      final skipNumber = _allAffiliatesIndex * _skip;
      if(value == "Earnings up"){
        final affiliates = BlocProvider.of<AffiliatesBloc>(context);
        affiliates.add(GetMoreAffiliatesEarningFromLowToHighEvent(skipNumber));
      } else if(value == "Earnings down"){
        final affiliates = BlocProvider.of<AffiliatesBloc>(context);
        affiliates.add(GetMoreAffiliatesEarningFromHighToLowEvent(skipNumber));
      } else if(value == "Most parents"){
        final affiliates = BlocProvider.of<AffiliatesBloc>(context);
        affiliates.add(GetMoreMostParentAffiliateEvent(skipNumber));
      } else{
        final affiliates = BlocProvider.of<AffiliatesBloc>(context);
        affiliates.add(GetMoreAffiliatesEvent(skipNumber));
      }
      if (fetchedAffiliates.isNotEmpty) {
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

    final affiliates = BlocProvider.of<AffiliatesBloc>(context);
    affiliates.add(GetAffiliatesEvent(0));

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  @override
  void initState() {
    _allAffiliates = [];
    _firstLoad();
    _allAffiliatesController = ScrollController()..addListener(loadMore);
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
    affiliateSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            semiBoldText(value: "Affiliates", size: mobileHeaderFontSize, color: onBackgroundColor),
            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: affiliateSearchController,
                    onChanged: (value) {
                      final searchAffiliates = BlocProvider.of<SearchAffiliateBloc>(context);
                      searchAffiliates.add(SearchAffiliatesEvent(value));
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
                      hint: Center(child: Iconify(Mi.filter, size: 40, color: onBackgroundColor,)),
                      items: filter.map(buildMenuLocation).toList(),
                      onChanged: (value) => setState(() {
                        _allAffiliates = [];
                        this.value = value;
                        if(value == "Earnings up"){
                          final affiliates = BlocProvider.of<AffiliatesBloc>(context);
                          affiliates.add(GetAffiliatesEarningFromLowToHighEvent(0));
                        } else if(value == "Earnings down"){
                          final affiliates = BlocProvider.of<AffiliatesBloc>(context);
                          affiliates.add(GetAffiliatesEarningFromHighToLowEvent(0));
                        } else if(value == "Most parents"){
                          final affiliates = BlocProvider.of<AffiliatesBloc>(context);
                          affiliates.add(GetMostParentAffiliateEvent(0));
                        } else if(value == "Date"){
                          final affiliates = BlocProvider.of<AffiliatesBloc>(context);
                          affiliates.add(GetAffiliatesEvent(0));
                        }
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
            BlocConsumer<SearchAffiliateBloc, SearchState>(builder: (_, state) {
              if (state is SearchAffiliateSuccessful) {
                if (affiliateSearchController.text.isEmpty) {
                  return buildInitialInput();
                }
                return searchedAffiliates(affiliates: state.affiliate);
              } else if (state is SearchAffiliateLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else {
                return buildInitialInput();
              }
            }, listener: (_, state) {
              if (state is SearchAffiliateFailed) {
                buildErrorLayout(context: context, message: state.errorType);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return BlocConsumer<AffiliatesBloc, AffiliatesState>(builder: (_, state){
      if(state is GetAffiliatesSuccessfulState){
        return _allAffiliates.isEmpty
            ? Center(child: noDataBox(text: "No Affiliates!", description: "Affiliates will appear here."))
            : buildAffiliateLists();
      } else if(state is GetAffiliatesSocketErrorState) {
        return localAffiliateLists(localAffiliate: state.localAffiliate);
      } else if(state is GetAffiliatesLoadingState){
        return Center(child: loadingBox(),);
      } else if(state is GetAffiliatesFailedState) {
        return Center(
          child: errorBox(onPressed: (){
            final affiliates = BlocProvider.of<AffiliatesBloc>(context);
            affiliates.add(GetAffiliatesEvent(0));
          }),
        );
      }
      else{
        return Center(child: Text(""),);
      }
    }, listener: (_, state) {
      if(state is GetAffiliatesSuccessfulState){
        _allAffiliates.addAll(state.affiliates);
        fetchedAffiliates = state.affiliates;
      }
    });
  }

  Widget buildAffiliateLists(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            controller: _allAffiliatesController,
            shrinkWrap: true,
            itemCount: _allAffiliates.length,
            itemBuilder: (context, index) {
              return affiliateListBox(context: context, affiliate: _allAffiliates[index]);
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

  Widget localAffiliateLists({required List<LocalAffiliate> localAffiliate}){
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: localAffiliate.length,
        itemBuilder: (context, index) {
          return localAffiliateListBox(context: context, affiliate: localAffiliate[index]);
        });
  }

  Widget searchedAffiliates({required List<Affiliates> affiliates}){
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: affiliates.length,
        itemBuilder: (context, index) {
          return affiliateListBox(context: context, affiliate: affiliates[index]);
        });
  }

  DropdownMenuItem<String> buildMenuLocation(String filter) => DropdownMenuItem(
    value: filter,
    child: filter == "Earnings up" || filter == "Earnings down" ? Row(
      children: [
        Text(
          "Earnings",
          style: TextStyle(
            color: onBackgroundColor,
            fontSize: 14,
          ),
        ),
        filter != "Earnings up" ? Iconify(Ic.round_arrow_downward, size: 14, color: onBackgroundColor,) : Iconify(Ic.round_arrow_upward, size: 14, color: onBackgroundColor,)
      ],
    ) : Text(
      filter,
      style: TextStyle(
        color: onBackgroundColor,
        fontSize: 14,
      ),
    ),
  );

}