import 'dart:io';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/logo_image.dart';
import 'package:cash_admin_app/features/common_widgets/not_connected_widget.dart';
import 'package:cash_admin_app/features/common_widgets/require_field_flashbar.dart';
import 'package:cash_admin_app/features/customize/data/model/logo_image.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_bloc.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_event.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class CustomizeGeneralBody extends StatefulWidget {
  const CustomizeGeneralBody({Key? key}) : super(key: key);

  @override
  State<CustomizeGeneralBody> createState() => _CustomizeGeneralBodyState();
}

class _CustomizeGeneralBodyState extends State<CustomizeGeneralBody> {

  File? _pickedImage;
  Uint8List selectedLogoImage = Uint8List(8);
  String? contentType;
  List logoImageType = [];

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedLogoImage = webImage;
          _pickedImage = selected;
          contentType = lookupMimeType(image.path);
        });
      } else {
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedLogoImage = webImage;
          _pickedImage = selected;
          contentType = image.mimeType;
        });
      } else {
      }
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomizeBloc, CustomizeState>(listener: (_, state) {
      if (state is PutLogoImageFailed) {
        buildErrorLayout(context: context, message: state.errorType);
      } else if (state is PutLogoImageSuccessful) {
        final logoImage = BlocProvider.of<LogoImageBloc>(context);
        logoImage.add(GetLogoImageEvent());
      }
    }, builder: (_, state) {
      if (state is PutLogoImageLoading) {
        return buildInitialInput(isLoading: true);
      } else {
        return buildInitialInput(isLoading: false);
      }
    });
  }

  Widget buildInitialInput({required bool isLoading}) {
    return Provider.of<InternetConnectionStatus>(context) ==
        InternetConnectionStatus.disconnected ? Center(child: notConnectedWidget(),) : SingleChildScrollView(
      child: SizedBox(
        width: 450,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 450,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Text("Logo", style: TextStyle(color: onBackgroundColor, fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(height: 10,),
                  selectedLogoImage.toString() != "[0, 0, 0, 0, 0, 0, 0, 0]" ?
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(selectedLogoImage, width: 160, height: 51, fit: BoxFit.cover,))
                      : PlatformLogoImage(logoBorderRadius: 10, logoHeight: 51, logoWidth: 160),
                  SizedBox(height: 10,),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                      onPressed: () {
                        _pickImage();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(3)),
                          padding:
                          const EdgeInsets.symmetric(vertical: 19)),
                      child: const Iconify(
                        Bi.upload,
                        color: onPrimaryColor,
                        size: defaultFontSize,
                      ))),
                  SizedBox(height: 40,),
                  SizedBox(width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if(selectedLogoImage.toString() != "[0, 0, 0, 0, 0, 0, 0, 0]"){
                            if(contentType.toString() != "null"){
                              List type = contentType!.split("/");
                              logoImageType = type;
                            }
                            final putLogoImage = BlocProvider.of<CustomizeBloc>(context);
                            putLogoImage.add(PutLogoImageEvent(LogoImage(logoImage: selectedLogoImage), logoImageType));
                          } else{
                            requireFlashBar(context: context, message: "Image not selected");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(3)),
                            padding:
                            const EdgeInsets.symmetric(vertical: 19)),
                        child: isLoading ? SizedBox(height: defaultFontSize, width: defaultFontSize, child: CircularProgressIndicator(color: onPrimaryColor,),) : Text("Update Logo", style: TextStyle(color: onPrimaryColor, fontSize: defaultFontSize),)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
