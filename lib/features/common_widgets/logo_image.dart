import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/features/common_widgets/blink_container.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_bloc.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_event.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progressive_image/progressive_image.dart';

class PlatformLogoImage extends StatelessWidget {
  double logoBorderRadius, logoWidth, logoHeight;

  PlatformLogoImage(
      {required this.logoBorderRadius,
      required this.logoWidth,
      required this.logoHeight});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogoImageBloc, LogoImageState>(builder: (_, state) {
      if (state is GetLogoImageLoadingState) {
        return BlinkContainer(width: logoWidth, height: logoHeight, borderRadius: 0,);
      } else if (state is GetLogoImageSuccessfulState) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(logoBorderRadius),
            child: ProgressiveImage(
              placeholder: AssetImage('images/loading.png'),
              thumbnail: MemoryImage(state.logoImage.logoImage),
              image: MemoryImage(state.logoImage.logoImage),
              width: logoWidth,
              height: logoHeight,
              fit: BoxFit.fitHeight,
            ));
      } else if (state is GetLogoImageFailedState) {
        return SizedBox();
      } else {
        return SizedBox();
      }
    });
  }
}
