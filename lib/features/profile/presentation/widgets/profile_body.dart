import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/router/route_utils.dart';
import 'package:cash_admin_app/core/services/app_service.dart';
import 'package:cash_admin_app/features/common_widgets/bold_text.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/loading_box.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/profile/data/models/admin.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_state.dart';
import 'package:cash_admin_app/features/profile/presentation/widgets/change_password_button.dart';
import 'package:cash_admin_app/features/profile/presentation/widgets/change_username_textformfield.dart';
import 'package:cash_admin_app/features/profile/presentation/widgets/signout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {

  num value = 0;

  @override
  void initState() {
    // final admin = BlocProvider.of<ProfileBloc>(context);
    // admin..add(LoadAdminEvent());
    getCommissionRateValue();
    // TODO: implement initState
    super.initState();
  }

  Future getCommissionRateValue() async {
    await getCommissionRate().then((value) {
      setState(() {
        this.value = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).size.width < 1100 ? EdgeInsets.symmetric(horizontal: 30) : EdgeInsets.symmetric(horizontal: 300),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (_, state) {
            if (state is LoadAdminFailed) {
              return errorBox(onPressed: (){
                final admin =
                BlocProvider.of<ProfileBloc>(context);
                admin.add(LoadAdminEvent());
              });
            } else if (state is LoadAdminSuccessful) {
              return buildInitialInput(admin: state.admin);
            } else if (state is LoadingAdmin) {
              return Center(child: loadingBox(),);
            } else {
              return Center(
                child: Text(""),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildInitialInput({required Admin admin}) {
    final appService = Provider.of<AppService>(context, listen: true);
    print(admin.id);
    print(admin.commissionRate);
    print(admin.username);
    print(admin.email);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: desktopTopPadding,
        ),
        Center(
          child: RichText(
            text: TextSpan(
              text: AppLocalizations.of(context)!.hello,
              style: TextStyle(fontSize: 30, color: onBackgroundColor),
              children: <TextSpan>[
                TextSpan(
                    text: " " + AppLocalizations.of(context)!.admin,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: onBackgroundColor)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Divider(
          color: surfaceColor,
          thickness: 1.0,
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: boldText(value: "Username", size: 17, color: blackColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: appService.isEditUsername
                  ? changeUsernameTextFormField(
                  context: context, username: admin.username!)
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: normalText(
                        value: admin.username!,
                        size: 17,
                        color: onBackgroundColor),
                  ),
                  IconButton(
                      onPressed: () {
                        print(appService.isEditUsername);
                        appService.changeIsEditUsername(true);
                        print(appService.isEditUsername);
                      },
                      icon: Iconify(
                        Eva.edit_2_outline,
                        size: 24,
                        color: primaryColor,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: boldText(value: "Email", size: 17, color: blackColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: normalText(
                        value: admin.email!, size: 17, color: onBackgroundColor),
                  ),
                  IconButton(
                      onPressed: () {
                        context.push(APP_PAGE.editEmail.toPath);
                      },
                      icon: Iconify(
                        Eva.edit_2_outline,
                        size: 24,
                        color: primaryColor,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
        SizedBox(
          height: 25,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boldText(value: "Commission", size: 17, color: blackColor),
                  normalText(
                      value: "${admin.commissionRate}" + "%",
                      size: 17,
                      color: blackColor)
                ],
              ),
            ),
            SliderTheme(
              data: SliderThemeData(
                  activeTickMarkColor: Colors.transparent,
                  activeTrackColor: Colors.orange,
                  inactiveTrackColor: Colors.black,
                  inactiveTickMarkColor: Colors.transparent,
                  showValueIndicator: ShowValueIndicator.always,
                  thumbColor: Colors.orange),
              child: Slider(
                min: 0,
                max: 100,
                divisions: 100,
                label: value.round().toString(),
                value: value.toDouble(),
                onChangeEnd: (value) {
                  final changeCommissionRate =
                  BlocProvider.of<ProfileBloc>(context);
                  changeCommissionRate
                      .add(ChangeCommissionRateEvent(value.round()));
                },
                onChanged: (value) {
                  setState(() => this.value = value);
                  print(value.round());
                },
              ),
            ),
          ],
        ),
        Divider(
          color: surfaceColor,
          thickness: 1.0,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText(value: "Actions", size: 17, color: blackColor),
              SizedBox(height: 10,),
              changePasswordButton(context: context),
              SizedBox(height: 10,),
              signoutButton(context),
            ],
          ),
        )
      ],
    );
  }

}
