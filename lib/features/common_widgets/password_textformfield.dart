import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/features/common_widgets/bold_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({Key? key}) : super(key: key);

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _secureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        boldText(value: AppLocalizations.of(context)!.password, size: defaultFontSize, color: onBackgroundColor),
        const SizedBox(
          height: smallSpacing,
        ),
        TextFormField(
          controller: passwordController,
          validator: (value){
            if(value!.isEmpty){
              return "Value can not be empty";
            }
            else{
              return null;
            }
          },
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enter_password,
              hintStyle: const TextStyle(color: textInputPlaceholderColor),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: textInputBorderColor),
                borderRadius: BorderRadius.all(
                  Radius.circular(defaultRadius),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: dangerColor),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _secureText = !_secureText;
                  });
                },
                icon: Icon(
                  _secureText == true ? Icons.visibility : Icons.visibility_off,
                  color: onBackgroundColor,
                ),
              )
          ),
          obscureText: _secureText,
        ),
      ],
    );
  }
}
