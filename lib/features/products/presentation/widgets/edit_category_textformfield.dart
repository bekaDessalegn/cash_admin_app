import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/services/app_service.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:provider/provider.dart';

Widget changeCategoryNameTextFormField({required BuildContext context,required String? categoryId, required String categoryName}){

  TextEditingController changeCategoryNameController = TextEditingController();
  changeCategoryNameController.text = categoryName;
  late AppService appService;
  appService = Provider.of<AppService>(context, listen: false);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: TextFormField(
          controller: changeCategoryNameController,
          validator: (value){
            if(value!.isEmpty){
              return "Value can not be empty";
            }
            else{
              return null;
            }
          },
          onChanged: (value){},
          decoration: const InputDecoration(
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
      ),
      IconButton(
          onPressed: () {
            // appService.changeIsPatchCategoryName(false);
            final patchCategory = BlocProvider.of<PostCategoriesBloc>(context);
            patchCategory.add(PatchCategoryEvent(categoryId, changeCategoryNameController.text));
            print(changeCategoryNameController.text);
          },
          icon: Iconify(
            Ic.baseline_done,
            size: 24,
            color: primaryColor,
          ))
    ],
  );
}