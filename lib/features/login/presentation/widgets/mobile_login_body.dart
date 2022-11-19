import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:cash_admin_app/features/common_widgets/bold_text.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/main_logo.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/password_textformfield.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_bloc.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_state.dart';
import 'package:cash_admin_app/features/login/presentation/widgets/language_picker_widget.dart';
import 'package:cash_admin_app/features/common_widgets/username_textformfield.dart';
import 'package:cash_admin_app/features/login/presentation/widgets/login_button.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MobileLoginBody extends StatefulWidget {

  @override
  State<MobileLoginBody> createState() => _MobileLoginBodyState();
}

class _MobileLoginBodyState extends State<MobileLoginBody> {

  final _prefs = PrefService();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return BlocConsumer<LoginBloc, LoginState>(
        listener: (_, state){
          if(state is LoginFailedState){
            buildErrorLayout(context: context, message: state.errorType);
          }
          else if(state is LoginPassedState){
            print("passed");
            _prefs.createCache("passed").whenComplete(() {
              authService.login();
              final admin = BlocProvider.of<ProfileBloc>(context);
              admin.add(LoadAdminEvent());
              context.go(APP_PAGE.home.toPath);
            });
          }
        },
        builder: (_, state){
          if(state is LoginLoadingState){
            print("Loading");
            return buildInitialInput(context: context, isLoading: true);
          }
          else{
            return buildInitialInput(context: context, isLoading: false);
          }
        });
  }

  Widget buildInitialInput({required BuildContext context, required isLoading}) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Form(
      key: formkey,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          width: w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Center(child: mainLogo()
              ),
              SizedBox(
                height: h / 15,
              ),
              Center(
                  child: normalText(value: AppLocalizations.of(context)!.hello, size: h1FontSize, color: onBackgroundColor)),
              Center(
                  child: boldText(value: AppLocalizations.of(context)!.admin, size: h1FontSize, color: onBackgroundColor)
              ),
              SizedBox(
                height: h / 12,
              ),
              normalText(value: AppLocalizations.of(context)!.sign_in_request, size: defaultFontSize, color: onBackgroundColor),
              const SizedBox(
                height: mediumSpacing,
              ),
              UsernameFormField(),
              const SizedBox(
                height: defaultSpacing,
              ),
              const PasswordTextFormField(),
              SizedBox(
                height: h / 20,
              ),
              SizedBox(width: w, child:
              loginButton(context: context, text: AppLocalizations.of(context)!.login, isLoading: isLoading)
              ),
              const SizedBox(
                height: smallSpacing,
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      context.push(APP_PAGE.forgotPassword.toPath);
                    },
                    child: normalText(value: AppLocalizations.of(context)!.forgot_password, size: defaultFontSize, color: primaryColor)),
              ),
            ],
          ),
        ),
      ),
  ),
    );
  }
}
