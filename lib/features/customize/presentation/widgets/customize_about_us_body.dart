import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/require_field_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:cash_admin_app/features/common_widgets/youtube_link_textformfield.dart';
import 'package:cash_admin_app/features/customize/data/model/about_content.dart';
import 'package:cash_admin_app/features/customize/data/model/about_us_image.dart';
import 'package:cash_admin_app/features/customize/data/model/how_tos.dart';
import 'package:cash_admin_app/features/customize/data/model/image.dart';
import 'package:cash_admin_app/features/customize/data/model/who_are_we.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_bloc.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_event.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_state.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/customize_description_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:progressive_image/progressive_image.dart';

class CustomizeAboutUsBody extends StatefulWidget {
  const CustomizeAboutUsBody({Key? key}) : super(key: key);

  @override
  State<CustomizeAboutUsBody> createState() => _CustomizeAboutUsBodyState();
}

class _CustomizeAboutUsBodyState extends State<CustomizeAboutUsBody> {
  File? _pickedAboutUsImage;
  Uint8List selectedAboutUsWebImage = Uint8List(8);
  String? aboutUsContentType;
  List aboutUsImageType = [];

  File? _pickedWhoAreWeImage;
  Uint8List selectedWhoAreWeWebImage = Uint8List(8);
  String? whoAreWeContentType;
  List whoAreWeImageType = [];

  TextEditingController whoAreWeVideoLinkController = TextEditingController();
  var whoAreWeDescriptionController = quill.QuillController.basic();
  var howToBuyFromUsController = quill.QuillController.basic();
  var howToAffiliateWithUsController = quill.QuillController.basic();
  TextEditingController howToAffiliateWithUsVideoLinkController =
      TextEditingController();

  final whoAreWeFormKey = GlobalKey<FormState>();
  final howTosFormKey = GlobalKey<FormState>();

  Future<void> _pickAboutUsImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedAboutUsImage = selected;
        });
      } else {}
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedAboutUsWebImage = webImage;
          _pickedAboutUsImage = selected;
          aboutUsContentType = image.mimeType;
        });
      } else {}
    } else {}
  }

  Future<void> _pickWhoAreWeImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedWhoAreWeImage = selected;
        });
      } else {}
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedWhoAreWeWebImage = webImage;
          _pickedWhoAreWeImage = selected;
          whoAreWeContentType = image.mimeType;
        });
      } else {}
    } else {}
  }

  @override
  void initState() {
    final aboutUsContent = BlocProvider.of<AboutUsContentBloc>(context);
    aboutUsContent.add(GetAboutUsContentEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AboutUsContentBloc, AboutUsContentState>(
        listener: (_, state) {
      if (state is GetAboutUsContentSuccessfulState) {
        whoAreWeVideoLinkController.text =
            state.aboutUsContent.whoAreWeVideoLink;
        howToAffiliateWithUsVideoLinkController.text =
            state.aboutUsContent.howToAffiliateWithUsVideoLink;
        var whoAreWeDescriptionJSON =
            jsonDecode(state.aboutUsContent.whoAreWeDescription);
        whoAreWeDescriptionController = quill.QuillController(
            document: quill.Document.fromJson(whoAreWeDescriptionJSON),
            selection: TextSelection.collapsed(offset: 0));
        var howToAffiliateWithUsJSON =
            jsonDecode(state.aboutUsContent.howToAffiliateWithUsDescription);
        howToAffiliateWithUsController = quill.QuillController(
            document: quill.Document.fromJson(howToAffiliateWithUsJSON),
            selection: TextSelection.collapsed(offset: 0));
        var howToBuyFromUsJSON =
            jsonDecode(state.aboutUsContent.howToBuyFromUsDescription);
        howToBuyFromUsController = quill.QuillController(
            document: quill.Document.fromJson(howToBuyFromUsJSON),
            selection: TextSelection.collapsed(offset: 0));
      }
    }, builder: (_, state) {
      if (state is GetAboutUsContentLoadingState) {
        return Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      } else if (state is GetAboutUsContentSuccessfulState) {
        return buildInitialInput(aboutUsContent: state.aboutUsContent);
      } else if (state is GetAboutUsContentFailedState) {
        return errorBox(onPressed: () {
          final aboutUsContent = BlocProvider.of<AboutUsContentBloc>(context);
          aboutUsContent.add(GetAboutUsContentEvent());
        });
      } else {
        return SizedBox();
      }
    });
  }

  Widget buildInitialInput({required AboutUsContent aboutUsContent}) {
    return SingleChildScrollView(
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
                  SizedBox(
                    height: 30,
                  ),
                  BlocConsumer<CustomizeBloc, CustomizeState>(
                      listener: (_, state) {
                    if (state is PutAboutUsImageFailed) {
                      buildErrorLayout(
                          context: context, message: state.errorType);
                    } else if (state is PutAboutUsImageSuccessful) {
                      final aboutUsContent =
                          BlocProvider.of<AboutUsContentBloc>(context);
                      aboutUsContent.add(GetAboutUsContentEvent());
                    }
                  }, builder: (_, state) {
                    if (state is PutAboutUsImageLoading) {
                      return aboutUsImageSection(
                          aboutUsImage: aboutUsContent.aboutUsImage.path,
                          isLoading: true);
                    } else {
                      return aboutUsImageSection(
                          aboutUsImage: aboutUsContent.aboutUsImage.path,
                          isLoading: false);
                    }
                  }),
                  const SizedBox(
                    height: addProductVerticalSpacing,
                  ),
                  Divider(
                    color: surfaceColor,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: addProductVerticalSpacing,
                  ),
                  BlocConsumer<CustomizeBloc, CustomizeState>(
                      listener: (_, state) {
                    if (state is PutWhoAreWeFailed) {
                      buildErrorLayout(
                          context: context, message: state.errorType);
                    } else if (state is PutWhoAreWeSuccessful) {
                      final aboutUsContent =
                          BlocProvider.of<AboutUsContentBloc>(context);
                      aboutUsContent.add(GetAboutUsContentEvent());
                    }
                  }, builder: (_, state) {
                    if (state is PutWhoAreWeLoading) {
                      return whoAreWeSection(
                          whoAreWeImage: aboutUsContent.whoAreWeImage.path,
                          isLoading: true);
                    } else {
                      return whoAreWeSection(
                          whoAreWeImage: aboutUsContent.whoAreWeImage.path,
                          isLoading: false);
                    }
                  }),
                  const SizedBox(
                    height: addProductVerticalSpacing,
                  ),
                  Divider(
                    color: surfaceColor,
                    thickness: 1.0,
                  ),
                  const SizedBox(
                    height: addProductVerticalSpacing,
                  ),
                  BlocConsumer<CustomizeBloc, CustomizeState>(
                      listener: (_, state) {
                    if (state is PutHowTosFailed) {
                      buildErrorLayout(
                          context: context, message: state.errorType);
                    } else if (state is PutHowTosSuccessful) {
                      final aboutUsContent =
                          BlocProvider.of<AboutUsContentBloc>(context);
                      aboutUsContent.add(GetAboutUsContentEvent());
                    }
                  }, builder: (_, state) {
                    if (state is PutHowTosLoading) {
                      return howTosSection(isLoading: true);
                    } else {
                      return howTosSection(isLoading: false);
                    }
                  }),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget aboutUsImageSection(
      {required String aboutUsImage, required bool isLoading}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About us image",
          style: TextStyle(color: onBackgroundColor, fontSize: defaultFontSize),
        ),
        SizedBox(
          height: 10,
        ),
        selectedAboutUsWebImage.toString() != "[0, 0, 0, 0, 0, 0, 0, 0]"
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  selectedAboutUsWebImage,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ))
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ProgressiveImage(
                  placeholder: AssetImage('images/loading.png'),
                  thumbnail: NetworkImage("$baseUrl$aboutUsImage",),
                  image: NetworkImage("$baseUrl$aboutUsImage",),
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                )),
        SizedBox(
          height: 10,
        ),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _pickAboutUsImage();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    padding: const EdgeInsets.symmetric(vertical: 19)),
                child: const Iconify(
                  Bi.upload,
                  color: onPrimaryColor,
                  size: defaultFontSize,
                ))),
        const SizedBox(
          height: addProductVerticalSpacing,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                if (selectedAboutUsWebImage.toString() !=
                    "[0, 0, 0, 0, 0, 0, 0, 0]") {
                  if (aboutUsContentType.toString() != "null") {
                    List type = aboutUsContentType!.split("/");
                    aboutUsImageType = type;
                  }
                  final putAboutUsImage =
                      BlocProvider.of<CustomizeBloc>(context);
                  putAboutUsImage.add(PutAboutUsImageEvent(
                      AboutUsImage(
                          aboutUsImage: ImageContent(
                              path: selectedAboutUsWebImage.toString())),
                      aboutUsImageType));
                } else {
                  requireFlashBar(
                      context: context, message: "Image not selected");
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  padding: const EdgeInsets.symmetric(vertical: 19)),
              child: isLoading
                  ? SizedBox(
                      height: defaultFontSize,
                      width: defaultFontSize,
                      child: CircularProgressIndicator(
                        color: onPrimaryColor,
                      ),
                    )
                  : Text(
                      "Update About Us Image",
                      style: TextStyle(
                          color: onPrimaryColor, fontSize: defaultFontSize),
                    )),
        )
      ],
    );
  }

  Widget whoAreWeSection(
      {required String whoAreWeImage, required bool isLoading}) {
    return Form(
      key: whoAreWeFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Who are we image",
            style:
                TextStyle(color: onBackgroundColor, fontSize: defaultFontSize),
          ),
          SizedBox(
            height: 10,
          ),
          selectedWhoAreWeWebImage.toString() != "[0, 0, 0, 0, 0, 0, 0, 0]"
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    selectedWhoAreWeWebImage,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ProgressiveImage(
                    placeholder: AssetImage('images/loading.png'),
                    thumbnail: NetworkImage("$baseUrl$whoAreWeImage",),
                    image: NetworkImage("$baseUrl$whoAreWeImage",),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )),
          SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    _pickWhoAreWeImage();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      padding: const EdgeInsets.symmetric(vertical: 19)),
                  child: const Iconify(
                    Bi.upload,
                    color: onPrimaryColor,
                    size: defaultFontSize,
                  ))),
          SizedBox(
            height: addProductVerticalSpacing,
          ),
          youtubeTextFormField(
              type: "Who are we video link",
              hint: "Who are we video link",
              controller: whoAreWeVideoLinkController),
          SizedBox(
            height: addProductVerticalSpacing,
          ),
          semiBoldText(
              value: "Who are we description",
              size: defaultFontSize,
              color: onBackgroundColor),
          SizedBox(
            height: smallSpacing,
          ),
          quill.QuillToolbar.basic(
            controller: whoAreWeDescriptionController,
            toolbarIconSize: 17,
            showFontFamily: false,
            showSearchButton: false,
            showRedo: false,
            showUndo: false,
            showHeaderStyle: false,
            showDirection: false,
            showQuote: false,
            showCodeBlock: false,
            showIndent: true,
            showStrikeThrough: false,
            showListCheck: false,
            showBackgroundColorButton: false,
            showDividers: false,
            showInlineCode: false,
            showLink: false,
            showClearFormat: false,
          ),
          Container(
              height: 300,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultRadius),
                  border: Border.all(color: textInputBorderColor)),
              child: quill.QuillEditor.basic(
                  controller: whoAreWeDescriptionController, readOnly: false)),
          const SizedBox(
            height: addProductVerticalSpacing,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (whoAreWeFormKey.currentState!.validate()) {
                    if (whoAreWeContentType.toString() != "null") {
                      List type = whoAreWeContentType!.split("/");
                      whoAreWeImageType = type;
                    }
                    final whoAreWeDesc = jsonEncode(
                        whoAreWeDescriptionController.document
                            .toDelta()
                            .toJson());
                    final putWhoAreWeImage =
                        BlocProvider.of<CustomizeBloc>(context);
                    putWhoAreWeImage.add(PutWhoAreWeEvent(
                        WhoAreWeContent(
                            whoAreWeImage: ImageContent(
                                path: selectedWhoAreWeWebImage.toString()),
                            whoAreWeDescription: whoAreWeDesc,
                            whoAreWeVideoLink:
                                whoAreWeVideoLinkController.text),
                        whoAreWeImageType));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    padding: const EdgeInsets.symmetric(vertical: 19)),
                child: isLoading
                    ? SizedBox(
                        height: defaultFontSize,
                        width: defaultFontSize,
                        child: CircularProgressIndicator(
                          color: onPrimaryColor,
                        ),
                      )
                    : Text(
                        "Update Who Are We Content",
                        style: TextStyle(
                            color: onPrimaryColor, fontSize: defaultFontSize),
                      )),
          )
        ],
      ),
    );
  }

  Widget howTosSection({required bool isLoading}) {
    return Form(
      key: howTosFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          semiBoldText(
              value: "How to buy from us",
              size: defaultFontSize,
              color: onBackgroundColor),
          SizedBox(
            height: smallSpacing,
          ),
          quill.QuillToolbar.basic(
            controller: howToBuyFromUsController,
            toolbarIconSize: 17,
            showFontFamily: false,
            showSearchButton: false,
            showRedo: false,
            showUndo: false,
            showHeaderStyle: false,
            showDirection: false,
            showQuote: false,
            showCodeBlock: false,
            showIndent: true,
            showStrikeThrough: false,
            showListCheck: false,
            showBackgroundColorButton: false,
            showDividers: false,
            showInlineCode: false,
            showLink: false,
            showClearFormat: false,
          ),
          Container(
              height: 300,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultRadius),
                  border: Border.all(color: textInputBorderColor)),
              child: quill.QuillEditor.basic(
                  controller: howToBuyFromUsController, readOnly: false)),
          const SizedBox(
            height: addProductVerticalSpacing,
          ),
          youtubeTextFormField(
              type: "How to affiliate with us video link",
              hint: "How to affiliate with us video link",
              controller: howToAffiliateWithUsVideoLinkController),
          SizedBox(
            height: addProductVerticalSpacing,
          ),
          semiBoldText(
              value: "How to affiliate with us",
              size: defaultFontSize,
              color: onBackgroundColor),
          SizedBox(
            height: smallSpacing,
          ),
          quill.QuillToolbar.basic(
            controller: howToAffiliateWithUsController,
            toolbarIconSize: 17,
            showFontFamily: false,
            showSearchButton: false,
            showRedo: false,
            showUndo: false,
            showHeaderStyle: false,
            showDirection: false,
            showQuote: false,
            showCodeBlock: false,
            showIndent: true,
            showStrikeThrough: false,
            showListCheck: false,
            showBackgroundColorButton: false,
            showDividers: false,
            showInlineCode: false,
            showLink: false,
            showClearFormat: false,
          ),
          Container(
              height: 300,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultRadius),
                  border: Border.all(color: textInputBorderColor)),
              child: quill.QuillEditor.basic(
                  controller: howToAffiliateWithUsController, readOnly: false)),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (howTosFormKey.currentState!.validate()) {
                    final howToAffDesc = jsonEncode(
                        howToAffiliateWithUsController.document
                            .toDelta()
                            .toJson());
                    final howToBuyDesc = jsonEncode(
                        howToBuyFromUsController.document.toDelta().toJson());
                    final howTos = BlocProvider.of<CustomizeBloc>(context);
                    howTos.add(PutHowTosEvent(HowTos(
                        howToBuyFromUsDescription: howToBuyDesc,
                        howToAffiliateWithUsDescription: howToAffDesc,
                        howToAffiliateWithUsVideoLink:
                            howToAffiliateWithUsVideoLinkController.text)));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    padding: const EdgeInsets.symmetric(vertical: 19)),
                child: isLoading
                    ? SizedBox(
                        height: defaultFontSize,
                        width: defaultFontSize,
                        child: CircularProgressIndicator(
                          color: onPrimaryColor,
                        ),
                      )
                    : Text(
                        "Update How Tos",
                        style: TextStyle(
                            color: onPrimaryColor, fontSize: defaultFontSize),
                      )),
          )
        ],
      ),
    );
  }
}
