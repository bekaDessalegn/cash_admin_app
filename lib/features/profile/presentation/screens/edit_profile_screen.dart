import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/main_logo.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_state.dart';
import 'package:cash_admin_app/features/profile/presentation/widgets/confirm_change_password_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final changePasswordFormKey = GlobalKey<FormState>();

  bool oldSecureText = true;
  bool newSecureText = true;
  bool confirmSecureText = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<EditPasswordBloc, EditPasswordState>(listener: (_, state) {
          if (state is EditPasswordFailed) {
            buildErrorLayout(context: context, message: state.errorType);
          } else if (state is EditPasswordSuccessful) {
            context.go(APP_PAGE.profile.toPath);
          }
        }, builder: (_, state) {
          if (state is EditPasswordLoading) {
            return buildInitialInput(isLoading: true);
          } else {
            return buildInitialInput(isLoading: false);
          }
        }),
      ),
    );
  }

  Widget buildInitialInput({required bool isLoading}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: mainLogo(),
        ),
        semiBoldText(
            value: "Changing your password",
            size: 26,
            color: onBackgroundColor),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: changePasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: addProductVerticalSpacing,
                ),
                semiBoldText(
                    value: "Old Password",
                    size: defaultFontSize,
                    color: onBackgroundColor),
                const SizedBox(
                  height: smallSpacing,
                ),
                TextFormField(
                  controller: oldPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Value can not be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "",
                      hintStyle:
                      TextStyle(color: textInputPlaceholderColor),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10.0),
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            oldSecureText = !oldSecureText;
                          });
                        },
                        icon: Icon(
                          oldSecureText == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: onBackgroundColor,
                        ),
                      )),
                  obscureText: oldSecureText,
                ),
                const SizedBox(
                  height: addProductVerticalSpacing,
                ),
                semiBoldText(
                    value: "New Password",
                    size: defaultFontSize,
                    color: onBackgroundColor),
                const SizedBox(
                  height: smallSpacing,
                ),
                TextFormField(
                  controller: newPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Value can not be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "",
                      hintStyle:
                      TextStyle(color: textInputPlaceholderColor),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10.0),
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            newSecureText = !newSecureText;
                          });
                        },
                        icon: Icon(
                          newSecureText == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: onBackgroundColor,
                        ),
                      )),
                  obscureText: newSecureText,
                ),
                const SizedBox(
                  height: addProductVerticalSpacing,
                ),
                semiBoldText(
                    value: "Confirm Password",
                    size: defaultFontSize,
                    color: onBackgroundColor),
                const SizedBox(
                  height: smallSpacing,
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Value can not be empty";
                    } else if (value != newPasswordController.text) {
                      return "Both passwords must be the same";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "",
                      hintStyle:
                      TextStyle(color: textInputPlaceholderColor),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10.0),
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            confirmSecureText = !confirmSecureText;
                          });
                        },
                        icon: Icon(
                          confirmSecureText == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: onBackgroundColor,
                        ),
                      )),
                  obscureText: confirmSecureText,
                ),
                const SizedBox(
                  height: 40,
                ),
                confirmChangePasswordButton(
                    context: context,
                    changePasswordFormKey: changePasswordFormKey,
                    oldPasswordController: oldPasswordController,
                    newPasswordController: newPasswordController,
                    confirmPasswordController: confirmPasswordController,
                    isLoading: isLoading
                )
              ],
            ),
          ),
        )
      ],
    ),
  );

  Widget buildLoadingLayout() => Center(
    child: CircularProgressIndicator(
      color: primaryColor,
    ),
  );
}
