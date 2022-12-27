import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/affiliate/data/models/affiliates.dart';
import 'package:cash_admin_app/features/affiliate/data/models/children.dart';
import 'package:cash_admin_app/features/affiliate/data/models/parent_affiliate.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_bloc.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_event.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_state.dart';
import 'package:cash_admin_app/features/affiliate/presentation/widgets/children_widget.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/list_image.dart';
import 'package:cash_admin_app/features/common_widgets/loading_box.dart';
import 'package:cash_admin_app/features/common_widgets/socket_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:intl/intl.dart';

class AffiliateDetailsBody extends StatefulWidget {

  String userId;
  AffiliateDetailsBody(this.userId);

  @override
  State<AffiliateDetailsBody> createState() => _AffiliateDetailsBodyState();
}

class _AffiliateDetailsBodyState extends State<AffiliateDetailsBody> {

  @override
  void initState() {
    final affiliate_details = BlocProvider.of<SingleAffiliateBloc>(context);
    affiliate_details.add(GetSingleAffiliateEvent(widget.userId));
    final children = BlocProvider.of<ChildrenBloc>(context);
    children.add(GetChildrenEvent(widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingleAffiliateBloc, SingleAffiliateState>(
        builder: (_, state){
          if(state is GetSingleAffiliateSuccessfulState){
            return buildAffiliateDetails(affiliate: state.affiliate);
          } else if(state is GetSingleAffiliateLoadingState){
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(child: loadingBox()));
          } else if(state is GetSingleAffiliateSocketError){
            return Center(child: socketErrorWidget(onPressed: (){
              final affiliate_details = BlocProvider.of<SingleAffiliateBloc>(context);
              affiliate_details.add(GetSingleAffiliateEvent(widget.userId));
              final children = BlocProvider.of<ChildrenBloc>(context);
              children.add(GetChildrenEvent(widget.userId));
            }),);
          } else if(state is GetSingleAffiliateFailedState){
            return Center(
              child: SizedBox(
                height: 250,
                child: errorBox(onPressed: (){
                  final affiliate_details = BlocProvider.of<SingleAffiliateBloc>(context);
                  affiliate_details.add(GetSingleAffiliateEvent(widget.userId));
                }),
              ),
            );
          } else{
            return Center(child: Text(""),);
          }
        },
        listener: (_, state){
          if(state is GetSingleAffiliateSuccessfulState){
            final parent = BlocProvider.of<ParentAffiliateBloc>(context);
            parent.add(StartGetParentAffiliateEvent());
            if(state.affiliate.parentId.toString() != "null"){
              parent.add(GetParentAffiliateEvent(state.affiliate.parentId!));
            }
          }
        });
  }

  Widget buildAffiliateDetails({required Affiliates affiliate}) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: affiliate.avatar!.path == "null" ? Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        image: AssetImage("images/account.jpg"),
                        fit: BoxFit.cover)),
              ) : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: listImage(urlImage: "$baseUrl${affiliate.avatar!.path}")),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Full Name ",
                        style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,),
                      ),
                      Flexible(
                        child: Text(
                          "${affiliate.fullName}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: onBackgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phone ",
                        style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,),
                      ),
                      Flexible(
                        child: Text(
                          "${affiliate.phone}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: onBackgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email ",
                        style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,),
                      ),
                      Flexible(
                        child: Text(
                          "${affiliate.email}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: onBackgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Member since ",
                        style: TextStyle(
                          color: onBackgroundColor,
                          fontSize: 16,),
                      ),
                      Flexible(
                        child: Text(
                          "${DateFormat("dd/MM/yyyy").format(
                            DateTime.parse("${affiliate.memberSince}"),
                          )}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: onBackgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(color: surfaceColor, thickness: 1.0,),
            SizedBox(height: 10,),
            Text(
              "Earning info",
              style: TextStyle(
                color: onBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total earned ",
                  style: TextStyle(
                    color: onBackgroundColor,
                    fontSize: 16,),
                ),
                Flexible(
                  child: Text(
                    "${affiliate.wallet.totalMade.toStringAsFixed(2)} ETB",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Current balance ",
                  style: TextStyle(
                    color: onBackgroundColor,
                    fontSize: 16,),
                ),
                Flexible(
                  child: Text(
                    "${affiliate.wallet.currentBalance.toStringAsFixed(2)} ETB",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: onBackgroundColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            TextButton(onPressed: (){
              context.pushNamed(
                APP_PAGE.transactionBy.toName,
                params: {'user_id': affiliate.userId!},
              );
            },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "See transaction history",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Iconify(Ic.baseline_open_in_new, color: primaryColor, size: 16,),
                  ],
                )),
            SizedBox(height: 10,),
            Divider(color: surfaceColor, thickness: 1.0,),
            SizedBox(
              height: 10,
            ),
            Text(
              "Requests via your link",
              style: TextStyle(
                color: onBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${affiliate.affiliationSummary.acceptedRequests} Accepted requests",
              style: TextStyle(
                color: onBackgroundColor,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${affiliate.affiliationSummary.rejectedRequests} Rejected requests",
              style: TextStyle(
                color: onBackgroundColor,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${affiliate.affiliationSummary.totalRequests - (affiliate.affiliationSummary.acceptedRequests + affiliate.affiliationSummary.rejectedRequests)} Pending requests",
              style: TextStyle(
                color: onBackgroundColor,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${affiliate.affiliationSummary.totalRequests} Total requests",
              style: TextStyle(
                color: onBackgroundColor,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: surfaceColor,
              thickness: 1.0,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Affiliate chain",
              style: TextStyle(
                color: onBackgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,),
            ),
            SizedBox(height: 10,),
            BlocBuilder<ParentAffiliateBloc, ParentAffiliateState>(builder: (_, state){
              if(state is GetParentAffiliateSuccessfulState){
                return affiliateParent(affiliate: state.affiliate);
              } else {
                return SizedBox();
              }
            }),
            BlocConsumer<ChildrenBloc, ChildrenState>(builder: (_, state){
              if(state is GetChildrenSuccessfulState){
                return childrenList(children: state.children);
              } else if(state is GetSingleAffiliateLoadingState){
                return Center(child: CircularProgressIndicator(color: primaryColor,),);
              } else{
                return Center(child: Text(""),);
              }
            }, listener: (_, state){
              if(state is GetChildrenFailedState){
                errorBox(onPressed: (){
                  final children = BlocProvider.of<ChildrenBloc>(context);
                  children.add(GetChildrenEvent(widget.userId));
                });
              }
            }),
            // SizedBox(height: 10,),
            // Divider(color: surfaceColor, thickness: 1.0,),
            // SizedBox(height: 10,),
            // Text(
            //   "Actions",
            //   style: TextStyle(
            //     color: onBackgroundColor,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16,),
            // ),
            // SizedBox(height: 10,),
            // TextButton(onPressed: (){},
            //     style: TextButton.styleFrom(
            //         padding: EdgeInsets.zero
            //     ),
            //     child: boldText(value: "Delete affiliate", size: 16, color: dangerColor)),
          ],
        ),
      ),
    );
  }

  Widget childrenList({required List<Children> children}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        Text(
          "Children (${children.length})",
          style: TextStyle(
            color: onBackgroundColor,
            fontSize: 16,),
        ),
        SizedBox(height: 10,),
        ListView.builder(
            itemCount: children.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return childrenWidget(context: context, child: children[index]);
            }),
      ],
    );
  }

  Widget affiliateParent({required ParentAffiliate affiliate}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Parent ",
          style: TextStyle(
            color: onBackgroundColor,
            fontSize: 16,),
        ),
        Flexible(
          child: GestureDetector(
            onTap: (){
              if(affiliate.userId != "0") {
                final affiliate_details = BlocProvider.of<SingleAffiliateBloc>(context);
                affiliate_details.add(GetSingleAffiliateEvent(affiliate.userId));
              }
            },
            child: Text(
              "${affiliate.fullName}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

}
