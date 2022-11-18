import 'package:another_flushbar/flushbar.dart';
import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/main_logo.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_bloc.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_event.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_state.dart';
import 'package:cash_admin_app/features/login/presentation/widgets/send_reset_link_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

class ForgotPasswordScreen extends StatefulWidget {

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final forgotPasswordFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    final startScreen = BlocProvider.of<LoginBloc>(context);
    startScreen.add(InitialSendRecoveryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: BlocConsumer<LoginBloc, LoginState>(
                listener: (_, state){
                  if(state is SendRecoveryEmailFailed){
                    buildErrorLayout(context: context, message: state.errorType);
                  }
                },
                builder: (_, state){
                  if(state is SendRecoveryEmailLoading){
                    return buildInitialInput(context: context, isLoading: true);
                  }
                  else if(state is SendRecoveryEmailSuccessful){
                    return buildSuccessfulInput(context: context);
                  }
                  else{
                    return buildInitialInput(context: context, isLoading: false);
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget buildInitialInput({required BuildContext context, required bool isLoading}) => Form(
    key: forgotPasswordFormKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
        ),
        Center(
            child: mainLogo()),
        SizedBox(height: 50,),
        Center(
            child: Text(
              "Forgot Password",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: onBackgroundColor),
            )),
        SizedBox(
          height: 10,
        ),
        Text(
          "No Problem! Enter your email or username below and we will send you an email with instruction to reset your password.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              color: onBackgroundColor),
        ),
        SizedBox(
          height: 20,
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
        SizedBox(height: 20,),
        SizedBox(
          width: double.infinity,
          child: resetButton(context: context, forgotPasswordFormKey: forgotPasswordFormKey, emailController: emailController, isLoading: isLoading),
        ),
        SizedBox(height: 10,),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: isLoading ? null : (){
              context.go(APP_PAGE.login.toPath);
            },
            child: Center(
              child:normalText(
                  value: "Back to Login", size: 16, color: primaryColor),
            ),
          ),
        )
      ],
    ),
  );

  Widget buildSuccessfulInput({required BuildContext context}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 80,
      ),
      Center(
          child: mainLogo()),
      SizedBox(height: 80,),
      Center(child: Iconify(Ic.baseline_task_alt, color: primaryColor, size: 50,)),
      SizedBox(height: 10,),
      Center(
          child: Text(
            "Email sent",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: onBackgroundColor),
          )),
      SizedBox(
        height: 10,
      ),
      Text(
        "You will receive an email with further instructions on how to reset your password.",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14,
            color: onBackgroundColor),
      ),
      SizedBox(height: 20,),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.go(APP_PAGE.login.toPath);
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: normalText(
              value: "Log in", size: 16, color: onPrimaryColor),
        ),
      ),
    ],
  );
}
