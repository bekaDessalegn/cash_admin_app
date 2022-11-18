import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/normal_textformfield.dart';
import 'package:cash_admin_app/features/products/data/models/categories.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TextEditingController _categoryController = TextEditingController();
final _categoryFormKey = GlobalKey<FormState>();

Widget addCategoryDialog({required BuildContext context}){
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: BlocConsumer<PostCategoriesBloc, PostCategoriesState>(listener: (_, state) {
      if (state is PostCategoriesFailed) {
        buildErrorLayout(context: context, message: state.errorType);
      } else if (state is PostCategoriesSuccessful) {
        final categories = BlocProvider.of<CategoriesBloc>(context);
        categories.add(GetCategoriesEvent());
        _categoryController.clear();
        Navigator.pop(context);
      }
    }, builder: (_, state) {
      if (state is PostCategoriesLoading) {
        return _buildInitialInput(context: context, isLoading: true);
      } else {
        return _buildInitialInput(context: context, isLoading: false);
      }
    }),
  );
}

Widget _buildInitialInput({required BuildContext context, required bool isLoading}){
  return SizedBox(
    height: 180,
    width: MediaQuery.of(context).size.width < 500 ? double.infinity : 450,
    child: Form(
      key: _categoryFormKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            normalTextFormField(
                type: "Category",
                hint: "Product category",
                controller: _categoryController),
            SizedBox(height: 30,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                if(_categoryFormKey.currentState!.validate()){
                  final add_category = BlocProvider.of<PostCategoriesBloc>(context);
                  add_category.add(PostCategoriesEvent(Categories(categoryName: _categoryController.text)));
                }
              },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  child: isLoading
                      ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: onPrimaryColor,
                    ),
                  )
                      : normalText(
                      value: "Add",
                      size: 16,
                      color: onPrimaryColor),
              ),
            )
          ],
        ),
      ),
    ),
  );
}