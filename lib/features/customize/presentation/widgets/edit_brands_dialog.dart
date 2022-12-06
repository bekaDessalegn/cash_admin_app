import 'dart:io';
import 'dart:typed_data';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:cash_admin_app/features/common_widgets/normal_textformfield.dart';
import 'package:cash_admin_app/features/customize/data/model/brands.dart';
import 'package:cash_admin_app/features/customize/data/model/image.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_bloc.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_event.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_state.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/link_textformfield.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/rank_textformfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:image_picker/image_picker.dart';

class EditBrandsDialog extends StatefulWidget {

  String? id;
  String brandUrl, brandRank, brandImage;
  EditBrandsDialog({required this.id, required this.brandUrl, required this.brandRank, required this.brandImage});


  @override
  State<EditBrandsDialog> createState() => _EditBrandsDialogState();
}

class _EditBrandsDialogState extends State<EditBrandsDialog> {

  TextEditingController _brandsLinkUrlController = TextEditingController();
  TextEditingController _brandsRankController = TextEditingController();
  final _brandsFormKey = GlobalKey<FormState>();

  File? _pickedBrandsImage;
  Uint8List selectedWebBrandsImage = Uint8List(8);
  String? brandsContentType;
  List brandsImageType = [];
  List<Brands> selectedBrandList = [];

  Future<void> _pickBrandsImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          var selected = File(image.path);
          _pickedBrandsImage = selected;
        });
      } else {}
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedWebBrandsImage = webImage;
          _pickedBrandsImage = selected;
          brandsContentType = image.mimeType;
        });
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: BlocConsumer<CustomizeBloc, CustomizeState>(listener: (_, state) {
        if (state is PatchBrandsFailed) {
          buildErrorLayout(context: context, message: state.errorType);
        } else if (state is PatchBrandsSuccessful) {
          final homeContent = BlocProvider.of<HomeContentBloc>(context);
          homeContent.add(GetHomeContentEvent());
          Navigator.pop(context);
          // selectedBrandList.add(Brands(logoImage: ImageContent(path: selectedWebBrandsImage.toString()), link: brandsLinkUrlController.text, rank: int.parse(brandsRankController.text)));
        }
      }, builder: (_, state) {
        if (state is PatchBrandsLoading) {
          return buildInitialInput(context: context, isLoading: true, id: widget.id, brandImage: widget.brandImage);
        } else {
          _brandsLinkUrlController.text = widget.brandUrl;
          _brandsRankController.text = widget.brandRank;
          return buildInitialInput(context: context, isLoading: false, id: widget.id, brandImage: widget.brandImage);
        }
      }),
    );
  }

  Widget buildInitialInput({required BuildContext context, required bool isLoading, required String? id, required String brandImage}){
    return SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width < 500 ? double.infinity : 450,
      child: SingleChildScrollView(
        child: Form(
          key: _brandsFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Edit brand",
                    style: TextStyle(
                        color: onBackgroundColor, fontSize: defaultFontSize, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "Brand logo",
                  style: TextStyle(
                      color: onBackgroundColor, fontSize: defaultFontSize),
                ),
                SizedBox(height: 10,),
                selectedWebBrandsImage.toString() != "[0, 0, 0, 0, 0, 0, 0, 0]"
                    ? Image.memory(
                      selectedWebBrandsImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.fill,
                    )
                    : Image.network(
                      "$baseUrl$brandImage",
                      width: 80,
                      height: 80,
                      fit: BoxFit.fill,
                    ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _pickBrandsImage();
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
                linkTextFormField(
                    type: "Brand link url",
                    hint: "Brand link url",
                    controller: _brandsLinkUrlController),
                SizedBox(height: 10,),
                rankTextFormField(
                    type: "Brand rank",
                    hint: "Brand rank",
                    controller: _brandsRankController),
                SizedBox(height: 30,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){
                    if(_brandsFormKey.currentState!.validate()){
                      if (brandsContentType.toString() != "null") {
                        List type = brandsContentType!.split("/");
                        brandsImageType = type;
                      }
                      final patchBrand =
                      BlocProvider.of<CustomizeBloc>(context);
                      patchBrand.add(PatchBrandsEvent(
                          Brands(
                              logoImage: ImageContent(
                                  path: selectedWebBrandsImage.toString()),
                              link: _brandsLinkUrlController.text,
                              rank: _brandsRankController.text.isEmpty ? 0 : int.parse(_brandsRankController.text)),
                          brandsImageType, id!));
                      _brandsRankController.clear();
                      _brandsLinkUrlController.clear();
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