import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/normal_textformfield.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_bloc.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _categoryFormKey = GlobalKey<FormState>();

Widget editCategoryDialog({required BuildContext context, required String? categoryId, required String categoryName}){
  TextEditingController changeCategoryNameController = TextEditingController();
  changeCategoryNameController.text = categoryName;
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: BlocConsumer<PostCategoriesBloc, PostCategoriesState>(listener: (_, state) {
      if (state is PatchCategoriesFailed) {
        buildErrorLayout(context: context, message: state.errorType);
      } else if (state is PatchCategoriesSuccessful) {
        final categories = BlocProvider.of<CategoriesBloc>(context);
        categories.add(GetCategoriesEvent());
        changeCategoryNameController.clear();
        Navigator.pop(context);
      }
    }, builder: (_, state) {
      if (state is PatchCategoriesLoading) {
        return _buildInitialInput(context: context, categoryId: categoryId, changeCategoryNameController: changeCategoryNameController, isLoading: true);
      } else {
        return _buildInitialInput(context: context, categoryId: categoryId, changeCategoryNameController: changeCategoryNameController, isLoading: false);
      }
    }),
  );
}

Widget _buildInitialInput({required BuildContext context, required String? categoryId, required TextEditingController  changeCategoryNameController, required bool isLoading}){
  return SizedBox(
    height: 180,
    child: Form(
      key: _categoryFormKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            normalTextFormField(
                type: "Category",
                hint: "Product category",
                controller: changeCategoryNameController),
            SizedBox(height: 30,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                if(_categoryFormKey.currentState!.validate()){
                  final edit_category = BlocProvider.of<PostCategoriesBloc>(context);
                  edit_category.add(PatchCategoryEvent(categoryId, changeCategoryNameController.text));
                }
              },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10),
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
                    value: "Save",
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