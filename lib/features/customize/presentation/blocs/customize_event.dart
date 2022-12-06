import 'package:cash_admin_app/features/customize/data/model/about_us_image.dart';
import 'package:cash_admin_app/features/customize/data/model/brands.dart';
import 'package:cash_admin_app/features/customize/data/model/hero.dart';
import 'package:cash_admin_app/features/customize/data/model/how_tos.dart';
import 'package:cash_admin_app/features/customize/data/model/logo_image.dart';
import 'package:cash_admin_app/features/customize/data/model/social_links.dart';
import 'package:cash_admin_app/features/customize/data/model/what_makes_us_unique.dart';
import 'package:cash_admin_app/features/customize/data/model/who_are_we.dart';
import 'package:cash_admin_app/features/customize/data/model/why_us.dart';

abstract class CustomizeEvent{}

class PutLogoImageEvent extends CustomizeEvent {
  LogoImage logoImage;
  List imageType;
  PutLogoImageEvent(this.logoImage, this.imageType);
}

class PutHeroEvent extends CustomizeEvent {
  HeroContent hero;
  List imageType;
  PutHeroEvent(this.hero, this.imageType);
}

class PutAboutUsImageEvent extends CustomizeEvent {
  AboutUsImage aboutUsImage;
  List imageType;
  PutAboutUsImageEvent(this.aboutUsImage, this.imageType);
}

class PutWhyUsEvent extends CustomizeEvent {
  WhyUsContent whyUsContent;
  List imageType;
  PutWhyUsEvent(this.whyUsContent, this.imageType);
}

class PutWhatMakesUsUniqueEvent extends CustomizeEvent {
  WhatMakesUsUnique whatMakesUsUnique;
  List imageType;
  PutWhatMakesUsUniqueEvent(this.whatMakesUsUnique, this.imageType);
}

class PutWhoAreWeEvent extends CustomizeEvent {
  WhoAreWeContent whoAreWeContent;
  List imageType;
  PutWhoAreWeEvent(this.whoAreWeContent, this.imageType);
}

class PutHowTosEvent extends CustomizeEvent {
  HowTos howTos;
  PutHowTosEvent(this.howTos);
}

class PostBrandsEvent extends CustomizeEvent {
  Brands brands;
  List imageType;
  PostBrandsEvent(this.brands, this.imageType);
}

class PostSocialLinksEvent extends CustomizeEvent {
  SocialLinks socialLinks;
  List imageType;
  PostSocialLinksEvent(this.socialLinks, this.imageType);
}

class DeleteBrandEvent extends CustomizeEvent {
  String id;
  DeleteBrandEvent(this.id);
}

class DeleteSocialLinkEvent extends CustomizeEvent {
  String id;
  DeleteSocialLinkEvent(this.id);
}

class PatchBrandsEvent extends CustomizeEvent {
  Brands brands;
  List imageType;
  String id;
  PatchBrandsEvent(this.brands, this.imageType, this.id);
}

class PatchSocialLinksEvent extends CustomizeEvent {
  SocialLinks socialLinks;
  List imageType;
  String id;
  PatchSocialLinksEvent(this.socialLinks, this.imageType, this.id);
}

abstract class HomeContentEvent {}

class GetHomeContentEvent extends HomeContentEvent {}

abstract class LogoImageEvent {}

class GetLogoImageEvent extends LogoImageEvent {}

abstract class AboutUsContentEvent {}

class GetAboutUsContentEvent extends AboutUsContentEvent {}