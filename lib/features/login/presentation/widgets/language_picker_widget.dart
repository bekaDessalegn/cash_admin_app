import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/provider/locale_provider.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:provider/provider.dart';
import 'package:iconify_flutter/icons/ic.dart';

class LanguagePickerWidget extends StatelessWidget {
  const LanguagePickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Iconify(Ic.baseline_arrow_drop_down, color: onBackgroundColor,),
          items: L10n.all
              .map(
                (locale) {
                  final language = L10n.getLanguage(locale.languageCode);

                  return DropdownMenuItem(child: Center(
                    child: normalText(value: language, size: defaultFontSize, color: onBackgroundColor)
                  ),
                    value: locale,
                    onTap: (){
                    final provider = Provider.of<LocaleProvider>(context, listen: false);
                    provider.setLocale(locale);
                    },
                  );
                },
              )
              .toList(),
          onChanged: (_) {}),
    );
  }
}
