import 'package:cash_admin_app/features/customize/data/model/about_content.dart';
import 'package:cash_admin_app/features/customize/data/model/home_content.dart';
import 'package:cash_admin_app/features/customize/data/model/logo_image.dart';

abstract class CustomizeState {}

class InitialCustomizeState extends CustomizeState {}

class PutLogoImageSuccessful extends CustomizeState {}

class PutLogoImageLoading extends CustomizeState {}

class PutLogoImageFailed extends CustomizeState {
  final String errorType;
  PutLogoImageFailed(this.errorType);
}

class PutHeroSuccessful extends CustomizeState {}

class PutHeroLoading extends CustomizeState {}

class PutHeroFailed extends CustomizeState {
  final String errorType;
  PutHeroFailed(this.errorType);
}

class PutAboutUsImageSuccessful extends CustomizeState {}

class PutAboutUsImageLoading extends CustomizeState {}

class PutAboutUsImageFailed extends CustomizeState {
  final String errorType;
  PutAboutUsImageFailed(this.errorType);
}

class PutWhyUsSuccessful extends CustomizeState {}

class PutWhyUsLoading extends CustomizeState {}

class PutWhyUsFailed extends CustomizeState {
  final String errorType;
  PutWhyUsFailed(this.errorType);
}

class PutWhatMakesUsUniqueSuccessful extends CustomizeState {}

class PutWhatMakesUsUniqueLoading extends CustomizeState {}

class PutWhatMakesUsUniqueFailed extends CustomizeState {
  final String errorType;
  PutWhatMakesUsUniqueFailed(this.errorType);
}

class PutWhoAreWeSuccessful extends CustomizeState {}

class PutWhoAreWeLoading extends CustomizeState {}

class PutWhoAreWeFailed extends CustomizeState {
  final String errorType;
  PutWhoAreWeFailed(this.errorType);
}

class PutHowTosSuccessful extends CustomizeState {}

class PutHowTosLoading extends CustomizeState {}

class PutHowTosFailed extends CustomizeState {
  final String errorType;
  PutHowTosFailed(this.errorType);
}

class PostBrandsSuccessful extends CustomizeState {}

class PostBrandsLoading extends CustomizeState {}

class PostBrandsFailed extends CustomizeState {
  final String errorType;
  PostBrandsFailed(this.errorType);
}

class PostSocialLinksSuccessful extends CustomizeState {}

class PostSocialLinksLoading extends CustomizeState {}

class PostSocialLinksFailed extends CustomizeState {
  final String errorType;
  PostSocialLinksFailed(this.errorType);
}

class DeleteBrandSuccessful extends CustomizeState {}

class DeleteBrandLoading extends CustomizeState {}

class DeleteBrandFailed extends CustomizeState {
  final String errorType;
  DeleteBrandFailed(this.errorType);
}

class DeleteSocialLinkSuccessful extends CustomizeState {}

class DeleteSocialLinkLoading extends CustomizeState {}

class DeleteSocialLinkFailed extends CustomizeState {
  final String errorType;
  DeleteSocialLinkFailed(this.errorType);
}

class PatchBrandsSuccessful extends CustomizeState {}

class PatchBrandsLoading extends CustomizeState {}

class PatchBrandsFailed extends CustomizeState {
  final String errorType;
  PatchBrandsFailed(this.errorType);
}

class PatchSocialLinksSuccessful extends CustomizeState {}

class PatchSocialLinksLoading extends CustomizeState {}

class PatchSocialLinksFailed extends CustomizeState {
  final String errorType;
  PatchSocialLinksFailed(this.errorType);
}

abstract class HomeContentState {}

class InitialHomeContentState extends HomeContentState {}

class GetHomeContentSuccessfulState extends HomeContentState {
  HomeContent homeContent;
  GetHomeContentSuccessfulState(this.homeContent);
}

class GetHomeContentLoadingState extends HomeContentState {}

class GetHomeContentSocketErrorState extends HomeContentState {}

class GetHomeContentFailedState extends HomeContentState {
  String errorType;
  GetHomeContentFailedState(this.errorType);
}

abstract class LogoImageState {}

class InitialLogoImageState extends LogoImageState {}

class GetLogoImageSuccessfulState extends LogoImageState {
  LogoImage logoImage;
  GetLogoImageSuccessfulState(this.logoImage);
}

class GetLogoImageLoadingState extends LogoImageState {}

class GetLogoImageSocketErrorState extends LogoImageState {}

class GetLogoImageFailedState extends LogoImageState {
  String errorType;
  GetLogoImageFailedState(this.errorType);
}

abstract class AboutUsContentState {}

class InitialAboutUsContentState extends AboutUsContentState {}

class GetAboutUsContentSuccessfulState extends AboutUsContentState {
  AboutUsContent aboutUsContent;
  GetAboutUsContentSuccessfulState(this.aboutUsContent);
}

class GetAboutUsContentLoadingState extends AboutUsContentState {}

class GetAboutUsContentSocketErrorState extends AboutUsContentState {}

class GetAboutUsContentFailedState extends AboutUsContentState {
  String errorType;
  GetAboutUsContentFailedState(this.errorType);
}