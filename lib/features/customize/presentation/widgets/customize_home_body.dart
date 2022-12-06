import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/features/common_widgets/bullet_list.dart';
import 'package:cash_admin_app/features/common_widgets/error_box.dart';
import 'package:cash_admin_app/features/common_widgets/error_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/normal_textformfield.dart';
import 'package:cash_admin_app/features/common_widgets/require_field_flashbar.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:cash_admin_app/features/customize/data/model/brands.dart';
import 'package:cash_admin_app/features/customize/data/model/hero.dart';
import 'package:cash_admin_app/features/customize/data/model/home_content.dart';
import 'package:cash_admin_app/features/customize/data/model/image.dart';
import 'package:cash_admin_app/features/customize/data/model/social_links.dart';
import 'package:cash_admin_app/features/customize/data/model/what_makes_us_unique.dart';
import 'package:cash_admin_app/features/customize/data/model/why_us.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_bloc.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_event.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_state.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/customize_description_widget.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/delete_brands_dialog.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/delete_social_links_dialog.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/edit_brands_dialog.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/edit_social_links_dialog.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/link_textformfield.dart';
import 'package:cash_admin_app/features/customize/presentation/widgets/rank_textformfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:progressive_image/progressive_image.dart';

class CustomizeHomeBody extends StatefulWidget {
  const CustomizeHomeBody({Key? key}) : super(key: key);

  @override
  State<CustomizeHomeBody> createState() => _CustomizeHomeBodyState();
}

class _CustomizeHomeBodyState extends State<CustomizeHomeBody> {
  File? _pickedHeroImage;
  Uint8List selectedWebHeroImage = Uint8List(8);
  String? heroContentType;
  List heroImageType = [];

  File? _pickedWhyUsImage;
  Uint8List selectedWebWhyUsImage = Uint8List(8);
  String? whyUsContentType;
  List whyUsImageType = [];

  File? _pickedWhatMakesUsUniqueImage;
  Uint8List selectedWebWhatMakesUsUniqueImage = Uint8List(8);
  String? whatMakesUsUniqueContentType;
  List whatMakesUsUniqueImageType = [];

  File? _pickedSocialIconImage;
  Uint8List selectedWebSocialIconImage = Uint8List(8);
  String? socialIconContentType;
  List socialLinkImageType = [];
  List<SocialLinks> socialsList = [];

  File? _pickedBrandsImage;
  Uint8List selectedWebBrandsImage = Uint8List(8);
  String? brandsContentType;
  List brandsImageType = [];
  List<Brands> selectedBrandList = [];

  final socialLinkFormKey = GlobalKey<FormState>();
  final heroFormKey = GlobalKey<FormState>();
  final whyUsFormKey = GlobalKey<FormState>();
  final brandsFormKey = GlobalKey<FormState>();
  final whatMakesUsUniqueFormKey = GlobalKey<FormState>();

  TextEditingController heroShortTitleController = TextEditingController();
  TextEditingController heroLongTitleController = TextEditingController();
  TextEditingController whyUsTitleController = TextEditingController();
  TextEditingController whatMakesUsUniqueController = TextEditingController();
  TextEditingController socialLinkUrlController = TextEditingController();
  TextEditingController socialLinkRankController = TextEditingController();
  TextEditingController brandsRankController = TextEditingController();
  TextEditingController brandsLinkUrlController = TextEditingController();

  var heroDescriptionController = quill.QuillController.basic();
  var whyUsDescriptionController = quill.QuillController.basic();

  List whatMakesUsUniqueList = [];

  Future<void> _pickHeroImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedHeroImage = selected;
        });
      } else {}
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedWebHeroImage = webImage;
          _pickedHeroImage = selected;
          heroContentType = image.mimeType;
        });
      } else {}
    } else {}
  }

  Future<void> _pickWhyUsImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedWhyUsImage = selected;
        });
      } else {}
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedWebWhyUsImage = webImage;
          _pickedWhyUsImage = selected;
          whyUsContentType = image.mimeType;
        });
      } else {}
    } else {}
  }

  Future<void> _pickWhatMakesUsUniqueImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedWhatMakesUsUniqueImage = selected;
        });
      } else {}
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedWebWhatMakesUsUniqueImage = webImage;
          _pickedWhatMakesUsUniqueImage = selected;
          whatMakesUsUniqueContentType = image.mimeType;
        });
      } else {}
    } else {}
  }

  Future<void> _pickSocialIconImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedSocialIconImage = selected;
        });
      } else {}
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var webImage = await image.readAsBytes();
        var selected = File(image.path);
        setState(() {
          selectedWebSocialIconImage = webImage;
          _pickedSocialIconImage = selected;
          socialIconContentType = image.mimeType;
        });
      } else {}
    } else {}
  }

  Future<void> _pickBrandsImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
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
  void initState() {
    final homeContent = BlocProvider.of<HomeContentBloc>(context);
    homeContent.add(GetHomeContentEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  BlocConsumer<HomeContentBloc, HomeContentState>(
                      listener: (_, state) {
                    if (state is GetHomeContentSuccessfulState) {
                      whatMakesUsUniqueList = [];
                      selectedBrandList = [];
                      socialsList = [];
                      heroShortTitleController.text =
                          state.homeContent.heroShortTitle;
                      heroLongTitleController.text =
                          state.homeContent.heroLongTitle;
                      var heroDescriptionJSON =
                          jsonDecode(state.homeContent.heroDescription);
                      heroDescriptionController = quill.QuillController(
                          document:
                              quill.Document.fromJson(heroDescriptionJSON),
                          selection: TextSelection.collapsed(offset: 0));
                      var whyUsDescriptionJSON =
                          jsonDecode(state.homeContent.whyUsDescription);
                      whyUsDescriptionController = quill.QuillController(
                          document:
                              quill.Document.fromJson(whyUsDescriptionJSON),
                          selection: TextSelection.collapsed(offset: 0));
                      whyUsTitleController.text = state.homeContent.whyUsTitle;
                      whatMakesUsUniqueList
                          .addAll(state.homeContent.whatMakesUsUnique);
                      for (var brands in state.homeContent.brands) {
                        selectedBrandList.add(Brands.fromJson(brands));
                      }
                      for (var socials in state.homeContent.socialLinks) {
                        socialsList.add(SocialLinks.fromJson(socials));
                      }
                    }
                  }, builder: (_, state) {
                    if (state is GetHomeContentLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    } else if (state is GetHomeContentSuccessfulState) {
                      return buildInitialInput(homeContent: state.homeContent);
                    } else if (state is GetHomeContentFailedState) {
                      return errorBox(onPressed: () {
                        final homeContent =
                            BlocProvider.of<HomeContentBloc>(context);
                        homeContent.add(GetHomeContentEvent());
                      });
                    } else {
                      return SizedBox();
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInitialInput({required HomeContent homeContent}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocConsumer<CustomizeBloc, CustomizeState>(listener: (_, state) {
          if (state is PutHeroFailed) {
            buildErrorLayout(context: context, message: state.errorType);
          } else if (state is PutHeroSuccessful) {
            final homeContent = BlocProvider.of<HomeContentBloc>(context);
            homeContent.add(GetHomeContentEvent());
          }
        }, builder: (_, state) {
          if (state is PutHeroLoading) {
            return heroSection(homeContent: homeContent, isLoading: true);
          } else {
            return heroSection(homeContent: homeContent, isLoading: false);
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
        BlocConsumer<CustomizeBloc, CustomizeState>(listener: (_, state) {
          if (state is PutWhyUsFailed) {
            buildErrorLayout(context: context, message: state.errorType);
          } else if (state is PutWhyUsSuccessful) {
            final homeContent = BlocProvider.of<HomeContentBloc>(context);
            homeContent.add(GetHomeContentEvent());
          }
        }, builder: (_, state) {
          if (state is PutWhyUsLoading) {
            return whyUsSection(
                whyUsImage: homeContent.whyUsImage.path, isLoading: true);
          } else {
            return whyUsSection(
                whyUsImage: homeContent.whyUsImage.path, isLoading: false);
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
        BlocConsumer<CustomizeBloc, CustomizeState>(listener: (_, state) {
          if (state is PutWhatMakesUsUniqueFailed) {
            buildErrorLayout(context: context, message: state.errorType);
          } else if (state is PutWhatMakesUsUniqueSuccessful) {
            final homeContent = BlocProvider.of<HomeContentBloc>(context);
            homeContent.add(GetHomeContentEvent());
          }
        }, builder: (_, state) {
          if (state is PutWhatMakesUsUniqueLoading) {
            return whatMakesUsUniqueSection(
                whatMakesUsUniqueImage: homeContent.whatMakesUsUniqueImage.path,
                isLoading: true);
          } else {
            return whatMakesUsUniqueSection(
                whatMakesUsUniqueImage: homeContent.whatMakesUsUniqueImage.path,
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
        BlocConsumer<CustomizeBloc, CustomizeState>(listener: (_, state) {
          if (state is PostBrandsFailed) {
            buildErrorLayout(context: context, message: state.errorType);
          } else if (state is PostBrandsSuccessful) {
            final homeContent = BlocProvider.of<HomeContentBloc>(context);
            homeContent.add(GetHomeContentEvent());
          }
        }, builder: (_, state) {
          if (state is PostBrandsLoading) {
            return brandsSection(isLoading: true);
          } else {
            return brandsSection(isLoading: false);
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
        BlocConsumer<CustomizeBloc, CustomizeState>(listener: (_, state) {
          if (state is PostSocialLinksFailed) {
            buildErrorLayout(context: context, message: state.errorType);
          } else if (state is PostSocialLinksSuccessful) {
            final homeContent = BlocProvider.of<HomeContentBloc>(context);
            homeContent.add(GetHomeContentEvent());
          }
        }, builder: (_, state) {
          if (state is PostSocialLinksLoading) {
            return socialLinksSection(isLoading: true);
          } else {
            return socialLinksSection(isLoading: false);
          }
        }),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget heroSection(
      {required HomeContent homeContent, required bool isLoading}) {
    return Form(
      key: heroFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hero image",
            style:
                TextStyle(color: onBackgroundColor, fontSize: defaultFontSize),
          ),
          SizedBox(
            height: 10,
          ),
          (selectedWebHeroImage.toString() != "[0, 0, 0, 0, 0, 0, 0, 0]")
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    selectedWebHeroImage,
                    width: 200,
                    height: 120,
                    fit: BoxFit.fill,
                  ))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ProgressiveImage(
                    placeholder: AssetImage('images/loading.png'),
                    thumbnail: NetworkImage("$baseUrl${homeContent.heroImage.path}"),
                    image: NetworkImage("$baseUrl${homeContent.heroImage.path}"),
                    width: 200,
                    height: 120,
                    fit: BoxFit.fill,
                  )),
          SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    _pickHeroImage();
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
          normalTextFormField(
              type: "Hero short title",
              hint: "Hero short title",
              controller: heroShortTitleController),
          const SizedBox(
            height: addProductVerticalSpacing,
          ),
          normalTextFormField(
              type: "Hero long title",
              hint: "Hero long title",
              controller: heroLongTitleController),
          const SizedBox(
            height: addProductVerticalSpacing,
          ),
          semiBoldText(
              value: "Hero Description",
              size: defaultFontSize,
              color: onBackgroundColor),
          SizedBox(
            height: smallSpacing,
          ),
          quill.QuillToolbar.basic(
            controller: heroDescriptionController,
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
                  controller: heroDescriptionController, readOnly: false)),
          SizedBox(
            height: addProductVerticalSpacing,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (heroFormKey.currentState!.validate()) {
                    if (heroContentType.toString() != "null") {
                      List type = heroContentType!.split("/");
                      heroImageType = type;
                    }
                    final heroDesc = jsonEncode(
                        heroDescriptionController.document.toDelta().toJson());
                    final hero = BlocProvider.of<CustomizeBloc>(context);
                    hero.add(PutHeroEvent(
                        HeroContent(
                            heroImage: ImageContent(
                                path: selectedWebHeroImage.toString()),
                            heroShortTitle: heroShortTitleController.text,
                            heroLongTitle: heroLongTitleController.text,
                            heroDescription: heroDesc),
                        heroImageType));
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
                        "Update Hero",
                        style: TextStyle(
                            color: onPrimaryColor, fontSize: defaultFontSize),
                      )),
          ),
        ],
      ),
    );
  }

  Widget whyUsSection({required String whyUsImage, required bool isLoading}) {
    return Form(
      key: whyUsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why us image",
            style:
                TextStyle(color: onBackgroundColor, fontSize: defaultFontSize),
          ),
          SizedBox(
            height: 10,
          ),
          selectedWebWhyUsImage.toString() != "[0, 0, 0, 0, 0, 0, 0, 0]"
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    selectedWebWhyUsImage,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ProgressiveImage(
                    placeholder: AssetImage('images/loading.png'),
                    thumbnail: NetworkImage("$baseUrl$whyUsImage"),
                    image: NetworkImage("$baseUrl$whyUsImage"),
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
                    _pickWhyUsImage();
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
          normalTextFormField(
              type: "Why us title",
              hint: "Why us title",
              controller: whyUsTitleController),
          const SizedBox(
            height: addProductVerticalSpacing,
          ),
          semiBoldText(
              value: "Why us description",
              size: defaultFontSize,
              color: onBackgroundColor),
          SizedBox(
            height: smallSpacing,
          ),
          quill.QuillToolbar.basic(
            controller: whyUsDescriptionController,
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
                  controller: whyUsDescriptionController, readOnly: false)),
          SizedBox(
            height: addProductVerticalSpacing,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (whyUsFormKey.currentState!.validate()) {
                    if (whyUsContentType.toString() != "null") {
                      List type = whyUsContentType!.split("/");
                      whyUsImageType = type;
                    }
                    final whyUsDesc = jsonEncode(
                        whyUsDescriptionController.document.toDelta().toJson());
                    final whyUs = BlocProvider.of<CustomizeBloc>(context);
                    whyUs.add(PutWhyUsEvent(
                        WhyUsContent(
                            whyUsImage: ImageContent(
                                path: selectedWebWhyUsImage.toString()),
                            whyUsTitle: whyUsTitleController.text,
                            whyUsDescription: whyUsDesc),
                        whyUsImageType));
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
                        "Update Why Us Content",
                        style: TextStyle(
                            color: onPrimaryColor, fontSize: defaultFontSize),
                      )),
          ),
        ],
      ),
    );
  }

  Widget whatMakesUsUniqueSection(
      {required String whatMakesUsUniqueImage, required bool isLoading}) {
    return Form(
      key: whatMakesUsUniqueFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What makes us unique image",
            style:
                TextStyle(color: onBackgroundColor, fontSize: defaultFontSize),
          ),
          SizedBox(
            height: 10,
          ),
          selectedWebWhatMakesUsUniqueImage.toString() !=
                  "[0, 0, 0, 0, 0, 0, 0, 0]"
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    selectedWebWhatMakesUsUniqueImage,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ProgressiveImage(
                    placeholder: AssetImage('images/loading.png'),
                    thumbnail: NetworkImage("$baseUrl$whatMakesUsUniqueImage",),
                    image: NetworkImage("$baseUrl$whatMakesUsUniqueImage",),
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
                    _pickWhatMakesUsUniqueImage();
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
          semiBoldText(
              value: "What makes us unique",
              size: defaultFontSize,
              color: onBackgroundColor),
          SizedBox(
            height: smallSpacing,
          ),
          whatMakesUsUniqueList.isEmpty
              ? SizedBox()
              : ListView.builder(
                  itemCount: whatMakesUsUniqueList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                            child:
                                bulletList(text: whatMakesUsUniqueList[index])),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  whatMakesUsUniqueList.removeAt(index);
                                });
                              },
                              child: Iconify(
                                MaterialSymbols.delete_outline,
                                color: dangerColor,
                              )),
                        )
                      ],
                    );
                  }),
          TextFormField(
            controller: whatMakesUsUniqueController,
            validator: (value) {
              if (value!.isEmpty) {
                return "value can not be empty";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: "What makes us unique",
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
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (whatMakesUsUniqueFormKey.currentState!.validate()) {
                    setState(() {
                      whatMakesUsUniqueList
                          .add(whatMakesUsUniqueController.text);
                      whatMakesUsUniqueController.clear();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    padding: const EdgeInsets.symmetric(vertical: 19)),
                child: Text(
                  "Add What Makes Us Unique Content",
                  style: TextStyle(
                      color: onPrimaryColor, fontSize: defaultFontSize),
                )),
          ),
          SizedBox(
            height: addProductVerticalSpacing,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (whatMakesUsUniqueList.isNotEmpty) {
                    if (whatMakesUsUniqueContentType.toString() != "null") {
                      List type = whatMakesUsUniqueContentType!.split("/");
                      whatMakesUsUniqueImageType = type;
                    }
                    final whatMakesUsUnique =
                        BlocProvider.of<CustomizeBloc>(context);
                    whatMakesUsUnique.add(PutWhatMakesUsUniqueEvent(
                        WhatMakesUsUnique(
                            whatMakesUsUnique: whatMakesUsUniqueList,
                            whatMakesUsUniqueImage: ImageContent(
                                path: selectedWebWhatMakesUsUniqueImage
                                    .toString())),
                        whatMakesUsUniqueImageType));
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
                        "Update What Makes Us Unique Content",
                        style: TextStyle(
                            color: onPrimaryColor, fontSize: defaultFontSize),
                      )),
          ),
        ],
      ),
    );
  }

  Widget brandsSection({required bool isLoading}) {
    return Form(
      key: brandsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Brands",
            style:
                TextStyle(color: onBackgroundColor, fontSize: defaultFontSize),
          ),
          SizedBox(
            height: 10,
          ),
          selectedBrandList.isNotEmpty
              ? ListView.builder(
                  itemCount: selectedBrandList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: ProgressiveImage(
                                placeholder: AssetImage('images/loading.png'),
                                thumbnail: NetworkImage("$baseUrl${selectedBrandList[index].logoImage.path}",),
                                image: NetworkImage("$baseUrl${selectedBrandList[index].logoImage.path}",),
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            selectedBrandList[index].link,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: onBackgroundColor,
                                fontSize: defaultFontSize),
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EditBrandsDialog(
                                            id: selectedBrandList[index].id,
                                            brandUrl:
                                                selectedBrandList[index].link,
                                            brandRank: selectedBrandList[index]
                                                .rank
                                                .toString(),
                                            brandImage: selectedBrandList[index]
                                                .logoImage
                                                .path);
                                      });
                                },
                                child: Iconify(
                                  MaterialSymbols.edit_outline,
                                  color: primaryColor,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return deleteBrandDialog(
                                            context: context,
                                            id: "${selectedBrandList[index].id}");
                                      });
                                },
                                child: Iconify(
                                  MaterialSymbols.delete_outline,
                                  color: dangerColor,
                                )),
                          )
                        ],
                      ),
                    );
                  })
              : SizedBox(),
          Text(
            "Add new brand",
            style: TextStyle(
                color: onBackgroundColor,
                fontSize: defaultFontSize,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Brand logo",
            style:
                TextStyle(color: onBackgroundColor, fontSize: defaultFontSize),
          ),
          SizedBox(
            height: smallSpacing,
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
                    padding: const EdgeInsets.symmetric(vertical: 19)),
                child: const Iconify(
                  Bi.upload,
                  color: onPrimaryColor,
                  size: defaultFontSize,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          linkTextFormField(
              type: "Link url",
              hint: "Link url",
              controller: brandsLinkUrlController),
          SizedBox(
            height: 10,
          ),
          rankTextFormField(
              type: "Rank", hint: "Rank", controller: brandsRankController),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (brandsFormKey.currentState!.validate()) {
                    if (selectedWebBrandsImage.toString() !=
                        "[0, 0, 0, 0, 0, 0, 0, 0]") {
                      if (brandsContentType.toString() != "null") {
                        List type = brandsContentType!.split("/");
                        brandsImageType = type;
                      }
                      final postBrand = BlocProvider.of<CustomizeBloc>(context);
                      postBrand.add(PostBrandsEvent(
                          Brands(
                              logoImage: ImageContent(
                                  path: selectedWebBrandsImage.toString()),
                              link: brandsLinkUrlController.text,
                              rank: brandsRankController.text.isEmpty
                                  ? 0
                                  : int.parse(brandsRankController.text)),
                          brandsImageType));
                      brandsRankController.clear();
                      brandsLinkUrlController.clear();
                    } else {
                      requireFlashBar(
                          context: context, message: "Image not selected");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 19)),
                child: isLoading
                    ? SizedBox(
                        width: defaultFontSize,
                        height: defaultFontSize,
                        child: CircularProgressIndicator(
                          color: onPrimaryColor,
                        ))
                    : Text(
                        "Add Brand",
                        style: TextStyle(
                            color: onPrimaryColor, fontSize: defaultFontSize),
                      )),
          ),
        ],
      ),
    );
  }

  Widget socialLinksSection({required bool isLoading}) {
    return Form(
      key: socialLinkFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Socials",
            style:
                TextStyle(color: onBackgroundColor, fontSize: defaultFontSize),
          ),
          SizedBox(
            height: 10,
          ),
          socialsList.isNotEmpty ? selectedSocialsListView() : SizedBox(),
          SizedBox(
            height: 10,
          ),
          Text(
            "Add new social",
            style: TextStyle(
                color: onBackgroundColor,
                fontSize: defaultFontSize,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Icon",
            style:
                TextStyle(color: onBackgroundColor, fontSize: defaultFontSize),
          ),
          SizedBox(
            height: smallSpacing,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _pickSocialIconImage();
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
                )),
          ),
          SizedBox(
            height: 10,
          ),
          normalTextFormField(
              type: "Link url",
              hint: "Link url",
              controller: socialLinkUrlController),
          SizedBox(
            height: 10,
          ),
          rankTextFormField(
              type: "Rank", hint: "Rank", controller: socialLinkRankController),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (socialLinkFormKey.currentState!.validate()) {
                    if (selectedWebSocialIconImage.toString() !=
                        "[0, 0, 0, 0, 0, 0, 0, 0]") {
                      if (socialIconContentType.toString() != "null") {
                        List type = socialIconContentType!.split("/");
                        socialLinkImageType = type;
                      }
                      final postSocialLink =
                          BlocProvider.of<CustomizeBloc>(context);
                      postSocialLink.add(PostSocialLinksEvent(
                          SocialLinks(
                              logoImage: ImageContent(
                                  path: selectedWebSocialIconImage.toString()),
                              link: socialLinkUrlController.text,
                              rank: socialLinkRankController.text.isEmpty
                                  ? 0
                                  : int.parse(socialLinkRankController.text)),
                          socialLinkImageType));
                      socialLinkUrlController.clear();
                      socialLinkRankController.clear();
                    } else {
                      requireFlashBar(
                          context: context, message: "Image not selected");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 19)),
                child: isLoading
                    ? SizedBox(
                        width: defaultFontSize,
                        height: defaultFontSize,
                        child: CircularProgressIndicator(
                          color: onPrimaryColor,
                        ))
                    : Text(
                        "Add Social",
                        style: TextStyle(
                            color: onPrimaryColor, fontSize: defaultFontSize),
                      )),
          ),
        ],
      ),
    );
  }

  Widget selectedSocialsListView() {
    return ListView.builder(
        itemCount: socialsList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: ProgressiveImage(
                    placeholder: AssetImage('images/loading.png'),
                    thumbnail: NetworkImage("$baseUrl${socialsList[index].logoImage.path}",),
                    image: NetworkImage("$baseUrl${socialsList[index].logoImage.path}",),
                    width: 30,
                    height: 30,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  socialsList[index].link,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: onBackgroundColor, fontSize: defaultFontSize),
                )),
                SizedBox(
                  width: 10,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditSocialLinksDialog(
                                id: socialsList[index].id,
                                socialUrl: socialsList[index].link,
                                socialRank: socialsList[index].rank.toString(),
                                socialImage: socialsList[index].logoImage.path,
                              );
                            });
                      },
                      child: Iconify(
                        MaterialSymbols.edit_outline,
                        color: primaryColor,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return deleteSocialLinkDialog(
                                  context: context,
                                  id: "${socialsList[index].id}");
                            });
                      },
                      child: Iconify(
                        MaterialSymbols.delete_outline,
                        color: dangerColor,
                      )),
                )
              ],
            ),
          );
        });
  }
}
