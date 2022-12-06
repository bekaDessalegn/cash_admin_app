import 'dart:io';
import 'dart:typed_data';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/normal_textformfield.dart';
import 'package:cash_admin_app/features/customize/data/model/image.dart';
import 'package:cash_admin_app/features/customize/data/model/social_links.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_bloc.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_event.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_state.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/rank_textformfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:image_picker/image_picker.dart';

class EditSocialLinksDialog extends StatefulWidget {

  String? id;
  String socialUrl, socialRank, socialImage;
  EditSocialLinksDialog({required this.id, required this.socialUrl, required this.socialRank, required this.socialImage});

  @override
  State<EditSocialLinksDialog> createState() => _EditSocialLinksDialogState();
}

class _EditSocialLinksDialogState extends State<EditSocialLinksDialog> {

  TextEditingController _socialLinkUrlController = TextEditingController();
  TextEditingController _socialRankController = TextEditingController();
  final _socialFormKey = GlobalKey<FormState>();

  File? _pickedSocialLinkImage;
  Uint8List selectedWebSocialLinkImage = Uint8List(8);
  String? socialLinkContentType;
  List socialLinkImageType = [];
  List<SocialLinks> selectedSocialList = [];

  Future<void> _pickSocialImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          var selected = File(image.path);
          _pickedSocialLinkImage = selected;
        });
      } else {}
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedWebSocialLinkImage = webImage;
          _pickedSocialLinkImage = selected;
          socialLinkContentType = image.mimeType;
        });
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: BlocConsumer<CustomizeBloc, CustomizeState>(listener: (_, state) {
        if (state is PatchSocialLinksFailed) {
          buildErrorLayout(context: context, message: state.errorType);
        } else if (state is PatchSocialLinksSuccessful) {
          final homeContent = BlocProvider.of<HomeContentBloc>(context);
          homeContent.add(GetHomeContentEvent());
          Navigator.pop(context);
        }
      }, builder: (_, state) {
        if (state is PatchSocialLinksLoading) {
          return buildInitialInput(context: context, isLoading: true, id: widget.id, socialImage: widget.socialImage);
        } else {
          _socialLinkUrlController.text = widget.socialUrl;
          _socialRankController.text = widget.socialRank;
          return buildInitialInput(context: context, isLoading: false, id: widget.id, socialImage: widget.socialImage);
        }
      }),
    );
  }

  Widget buildInitialInput({required BuildContext context, required bool isLoading, required String? id, required String socialImage}){
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width < 500 ? double.infinity : 450,
      child: SingleChildScrollView(
        child: Form(
          key: _socialFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Edit social",
                    style: TextStyle(
                        color: onBackgroundColor, fontSize: defaultFontSize, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "Social logo",
                  style: TextStyle(
                      color: onBackgroundColor, fontSize: defaultFontSize),
                ),
                SizedBox(height: 10,),
                selectedWebSocialLinkImage.toString() != "[0, 0, 0, 0, 0, 0, 0, 0]"
                    ? Image.memory(
                      selectedWebSocialLinkImage,
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                    )
                    : Image.network(
                      "$baseUrl$socialImage",
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                    ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _pickSocialImage();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          padding:
                          const EdgeInsets.symmetric(vertical: 13)),
                      child: const Iconify(
                        Bi.upload,
                        color: onPrimaryColor,
                        size: defaultFontSize,
                      )),
                ),
                SizedBox(height: 10,),
                normalTextFormField(
                    type: "Social link url",
                    hint: "Social link url",
                    controller: _socialLinkUrlController),
                SizedBox(height: 10,),
                rankTextFormField(
                    type: "Social rank",
                    hint: "Social rank",
                    controller: _socialRankController),
                SizedBox(height: 30,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){
                    if(_socialFormKey.currentState!.validate()){
                        if (socialLinkContentType.toString() != "null") {
                          List type = socialLinkContentType!.split("/");
                          socialLinkImageType = type;
                        }
                        final patchSocial =
                        BlocProvider.of<CustomizeBloc>(context);
                        patchSocial.add(PatchSocialLinksEvent(
                            SocialLinks(
                                logoImage: ImageContent(
                                    path: selectedWebSocialLinkImage.toString()),
                                link: _socialLinkUrlController.text,
                                rank: _socialRankController.text.isEmpty ? 0 : int.parse(_socialRankController.text)),
                            socialLinkImageType, id!));
                        _socialRankController.clear();
                        _socialLinkUrlController.clear();
                      }
                  },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
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
                        value: "Edit",
                        size: 16,
                        color: onPrimaryColor),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}