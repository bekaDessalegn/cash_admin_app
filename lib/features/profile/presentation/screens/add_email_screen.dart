import 'package:another_flushbar/flushbar.dart';
import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/core/services/app_service.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/features/common_widgets/app_bar_widget.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_state.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/put_email_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/put_email_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/put_email_state.dart';
import 'package:cash_admin_app/features/profile/presentation/widgets/add_email_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AddEmailScreen extends StatefulWidget {
  @override
  State<AddEmailScreen> createState() => _AddEmailScreenState();
}

class _AddEmailScreenState extends State<AddEmailScreen> {
  final verifyEmailKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController verifyEmailController = TextEditingController();

  AuthService authService = AuthService();

  @override
  void initState() {
    final startEditEmail = BlocProvider.of<PutEmailBloc>(context);
    startEditEmail.add(InitialPutEmailEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: BlocConsumer<PutEmailBloc, PutEmailState>(listener: (_, state) {
        if (state is PutEmailFailed) {
          buildErrorLayout(
              context: context,
              message: state.errorType);
        } else if (state is VerifyEmailFailed) {
          buildErrorLayout(
              context: context,
              message: state.errorType);
        } else if (state is VerifyEmailSuccessful) {
          authService.setEmail(email: emailController.text);
          final admin = BlocProvider.of<ProfileBloc>(context);
          admin.add(LoadAdminEvent());
          context.go(APP_PAGE.home.toPath);
        }
      }, builder: (_, state) {
        if (state is PutEmailLoading) {
          return buildInitialInput(context: context, isLoading: true);
        } else if (state is PutEmailSuccessful) {
          return buildEmailEnteredInput(context: context);
        } else if (state is VerifyEmailLoading) {
          return buildLoadingLayout();
        }
        else if(state is VerifyEmailFailed){
          return buildEmailEnteredInput(context: context);
        }
        else {
          return buildInitialInput(context: context, isLoading: false);
        }
      }),
    );
  }

  Widget buildInitialInput({required BuildContext context, required bool isLoading}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          semiBoldText(value: "Add Email", size: 28, color: onBackgroundColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: verifyEmailKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: addProductVerticalSpacing,
                  ),
                  semiBoldText(
                      value: "Email",
                      size: defaultFontSize,
                      color: onBackgroundColor),
                  const SizedBox(
                    height: smallSpacing,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Value can not be empty";
                      } else if (RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return null;
                      } else {
                        return "Please enter valid email";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: textInputPlaceholderColor),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
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
                  const SizedBox(
                    height: addProductVerticalSpacing,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: addEmailButton(context: context, emailController: emailController, verifyEmailKey: verifyEmailKey, isLoading: isLoading),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildEmailEnteredInput({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 120,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/cash_logo.png"))),
            ),
          ),
          semiBoldText(value: "Add Email", size: 28, color: onBackgroundColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: verifyEmailKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: addProductVerticalSpacing,
                  ),
                  semiBoldText(
                      value: "Email",
                      size: defaultFontSize,
                      color: onBackgroundColor),
                  const SizedBox(
                    height: smallSpacing,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Value can not be empty";
                      } else if (RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return null;
                      } else {
                        return "Please enter valid email";
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: textInputPlaceholderColor),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
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
                  const SizedBox(
                    height: addProductVerticalSpacing,
                  ),
                  buildVerificationCode(),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (verifyEmailKey.currentState!.validate()) {
                          final verifyEmail =
                          BlocProvider.of<PutEmailBloc>(context);
                          verifyEmail.add(
                              VerifyEmailEvent(verifyEmailController.text));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: normalText(
                          value: "Verify", size: 20, color: onPrimaryColor),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildVerificationCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        semiBoldText(
            value: "Verification code has been sent to your email",
            size: defaultFontSize,
            color: onBackgroundColor),
        const SizedBox(
          height: smallSpacing,
        ),
        TextFormField(
          controller: verifyEmailController,
          validator: (value) {
            if (value!.isEmpty) {
              return "Value can not be empty";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            hintText: "Enter the verification code",
            hintStyle: TextStyle(color: textInputPlaceholderColor),
            contentPadding:
            EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
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
      ],
    );
  }

  Widget buildLoadingLayout() => Center(
    child: CircularProgressIndicator(
      color: primaryColor,
    ),
  );
}
