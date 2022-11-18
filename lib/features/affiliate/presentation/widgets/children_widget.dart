import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/affiliate/data/models/children.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_bloc.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget childrenWidget({required BuildContext context, required Children child}){
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: (){
                final affiliate_details = BlocProvider.of<SingleAffiliateBloc>(context);
                affiliate_details.add(GetSingleAffiliateEvent(child.userId));
              },
              child: Text(
                "${child.fullName}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Text(
          "${child.childrenCount} children",
          style: TextStyle(
            color: onBackgroundColor,
            fontSize: 16,),
        ),
      ],
    ),
  );
}