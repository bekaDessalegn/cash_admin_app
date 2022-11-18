import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/normal_textformfield.dart';
import 'package:cash_admin_app/features/products/data/models/categories.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget deleteCategoryDialog({required BuildContext context, required String? categoryId, required String categoryName}){
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: BlocConsumer<CategoriesBloc, CategoriesState>(listener: (_, state) {
      if (state is GetCategoriesFailed) {
        buildErrorLayout(context: context, message: state.errorType);
      } else if (state is GetCategoriesSuccessful) {
        Navigator.pop(context);
      }
    }, builder: (_, state) {
      if (state is GetCategoriesLoading) {
        return _buildInitialInput(context: context, categoryId: categoryId, categoryName: categoryName, isLoading: true);
      } else {
        return _buildInitialInput(context: context, categoryId: categoryId, categoryName: categoryName, isLoading: false);
      }
    }),
  );
}

Widget _buildInitialInput({required BuildContext context, required String? categoryId, required String categoryName, required bool isLoading}){
  return SizedBox(
    height: 150,
    width: MediaQuery.of(context).size.width < 1100 ? double.infinity : 400,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Delete category", style: TextStyle(
            color: onBackgroundColor,
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 10,),
          isLoading ? Center(child: CircularProgressIndicator(color: primaryColor,),) :
          Text("Are you sure you want to delete the category named $categoryName ?", style: TextStyle(
              color: onBackgroundColor,
              fontSize: 16
          ),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel", style: TextStyle(
                  color: onBackgroundColor,
                  fontSize: 16
              ),),),
              SizedBox(width: 10,),
              TextButton(onPressed: (){
                final deleteCategory = BlocProvider.of<CategoriesBloc>(context);
                deleteCategory.add(DeleteCategoryEvent(categoryId));
              }, child: Text("Delete", style: TextStyle(
                  color: dangerColor,
                  fontSize: 16
              ),),),
            ],
          )
        ],
      ),
    ),
  );
}