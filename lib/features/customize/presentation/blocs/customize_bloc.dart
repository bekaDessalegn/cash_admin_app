import 'package:cash_admin_app/features/customize/data/repository/customize_repository.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_event.dart';
import 'package:cash_admin_app/features/customize/presentation/blocs/customize_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomizeBloc extends Bloc<CustomizeEvent, CustomizeState> {
  CustomizeRepository customizeRepository;
  CustomizeBloc(this.customizeRepository) : super(InitialCustomizeState()){
    on<PutLogoImageEvent>(_onPutLogoImageEvent);
    on<PutHeroEvent>(_onPutHeroEvent);
    on<PutAboutUsImageEvent>(_onPutAboutUsImageEvent);
    on<PutWhyUsEvent>(_onPutWhyUsEvent);
    on<PutWhatMakesUsUniqueEvent>(_onPutWhatMakesUsUniqueEvent);
    on<PutWhoAreWeEvent>(_onPutWhoAreWeEvent);
    on<PutHowTosEvent>(_onPutHowTosEvent);
    on<PostBrandsEvent>(_onPostBrandsEvent);
    on<PatchBrandsEvent>(_onPatchBrandsEvent);
    on<PostSocialLinksEvent>(_onPostSocialLinksEvent);
    on<PatchSocialLinksEvent>(_onPatchSocialLinksEvent);
    on<DeleteBrandEvent>(_onDeleteBrandEvent);
    on<DeleteSocialLinkEvent>(_onDeleteSocialLinkEvent);
  }

  void _onPutLogoImageEvent(PutLogoImageEvent event, Emitter emit) async {
    emit(PutLogoImageLoading());
    try {
      await customizeRepository.putLogoImage(event.logoImage, event.imageType);
      emit(PutLogoImageSuccessful());
    } catch(e){
      emit(PutLogoImageFailed("Something went wrong"));
    }
  }

  void _onPutHeroEvent(PutHeroEvent event, Emitter emit) async {
    emit(PutHeroLoading());
    try {
      await customizeRepository.putHero(event.hero, event.imageType);
      emit(PutHeroSuccessful());
    } catch(e){
      emit(PutHeroFailed("Something went wrong"));
    }
  }

  void _onPutAboutUsImageEvent(PutAboutUsImageEvent event, Emitter emit) async {
    emit(PutAboutUsImageLoading());
    try {
      await customizeRepository.putAboutUsImage(event.aboutUsImage, event.imageType);
      emit(PutAboutUsImageSuccessful());
    } catch(e){
      emit(PutAboutUsImageFailed("Something went wrong"));
    }
  }

  void _onPutWhyUsEvent(PutWhyUsEvent event, Emitter emit) async {
    emit(PutWhyUsLoading());
    try {
      await customizeRepository.putWhyUsContent(event.whyUsContent, event.imageType);
      emit(PutWhyUsSuccessful());
    } catch(e){
      emit(PutWhyUsFailed("Something went wrong"));
    }
  }

  void _onPutWhatMakesUsUniqueEvent(PutWhatMakesUsUniqueEvent event, Emitter emit) async {
    emit(PutWhatMakesUsUniqueLoading());
    try {
      await customizeRepository.putWhatMakesUsUnique(event.whatMakesUsUnique, event.imageType);
      emit(PutWhatMakesUsUniqueSuccessful());
    } catch(e){
      emit(PutWhatMakesUsUniqueFailed("Something went wrong"));
    }
  }

  void _onPutWhoAreWeEvent(PutWhoAreWeEvent event, Emitter emit) async {
    emit(PutWhoAreWeLoading());
    try {
      await customizeRepository.putWhoAreWeContent(event.whoAreWeContent, event.imageType);
      emit(PutWhoAreWeSuccessful());
    } catch(e){
      emit(PutWhoAreWeFailed("Something went wrong"));
    }
  }

  void _onPutHowTosEvent(PutHowTosEvent event, Emitter emit) async {
    emit(PutHowTosLoading());
    try {
      await customizeRepository.putHowTos(event.howTos);
      emit(PutHowTosSuccessful());
    } catch(e){
      emit(PutHowTosFailed("Something went wrong"));
    }
  }

  void _onPostBrandsEvent(PostBrandsEvent event, Emitter emit) async {
    emit(PostBrandsLoading());
    try {
      await customizeRepository.postBrands(event.brands, event.imageType);
      emit(PostBrandsSuccessful());
    } catch(e){
      emit(PostBrandsFailed("Something went wrong"));
    }
  }

  void _onPatchBrandsEvent(PatchBrandsEvent event, Emitter emit) async {
    emit(PatchBrandsLoading());
    try {
      await customizeRepository.patchBrands(event.brands, event.imageType, event.id);
      emit(PatchBrandsSuccessful());
    } catch(e){
      emit(PatchBrandsFailed("Something went wrong"));
    }
  }

  void _onPostSocialLinksEvent(PostSocialLinksEvent event, Emitter emit) async {
    emit(PostSocialLinksLoading());
    try {
      await customizeRepository.postSocialLinks(event.socialLinks, event.imageType);
      emit(PostSocialLinksSuccessful());
    } catch(e){
      emit(PostSocialLinksFailed("Something went wrong"));
    }
  }

  void _onPatchSocialLinksEvent(PatchSocialLinksEvent event, Emitter emit) async {
    emit(PatchSocialLinksLoading());
    try {
      await customizeRepository.patchSocialLinks(event.socialLinks, event.imageType, event.id);
      emit(PatchSocialLinksSuccessful());
    } catch(e){
      emit(PatchSocialLinksFailed("Something went wrong"));
    }
  }

  void _onDeleteBrandEvent(DeleteBrandEvent event, Emitter emit) async {
    emit(DeleteBrandLoading());
    try {
      await customizeRepository.deleteBrand(event.id);
      emit(DeleteBrandSuccessful());
    } catch(e){
      emit(DeleteBrandFailed("Something went wrong deleting brand"));
    }
  }

  void _onDeleteSocialLinkEvent(DeleteSocialLinkEvent event, Emitter emit) async {
    emit(DeleteSocialLinkLoading());
    try {
      await customizeRepository.deleteSocialLink(event.id);
      emit(DeleteSocialLinkSuccessful());
    } catch(e){
      emit(DeleteSocialLinkFailed("Something went wrong deleting brand"));
    }
  }

}

class HomeContentBloc extends Bloc<HomeContentEvent, HomeContentState> {
  CustomizeRepository customizeRepository;
  HomeContentBloc(this.customizeRepository) : super(InitialHomeContentState()){
    on<GetHomeContentEvent>(_onGetHomeContentEvent);
  }

  void _onGetHomeContentEvent(GetHomeContentEvent event, Emitter emit) async {
    emit(GetHomeContentLoadingState());
    try {
      final homeContent = await customizeRepository.getHomeContent();
      emit(GetHomeContentSuccessfulState(homeContent));
    } catch(e){
      emit(GetHomeContentFailedState("Something went wrong fetching the home content"));
    }
  }

}

class LogoImageBloc extends Bloc<LogoImageEvent, LogoImageState> {
  CustomizeRepository customizeRepository;
  LogoImageBloc(this.customizeRepository) : super(InitialLogoImageState()){
    on<GetLogoImageEvent>(_onGetLogoImageEvent);
  }

  void _onGetLogoImageEvent(GetLogoImageEvent event, Emitter emit) async {
    emit(GetLogoImageLoadingState());
    try {
      final logoImage = await customizeRepository.getLogoImage();
      emit(GetLogoImageSuccessfulState(logoImage));
    } catch(e){
      emit(GetLogoImageFailedState("Something went wrong fetching the home content"));
    }
  }

}

class AboutUsContentBloc extends Bloc<AboutUsContentEvent, AboutUsContentState> {
  CustomizeRepository customizeRepository;
  AboutUsContentBloc(this.customizeRepository) : super(InitialAboutUsContentState()){
    on<GetAboutUsContentEvent>(_onGetAboutUsContentEvent);
  }

  void _onGetAboutUsContentEvent(GetAboutUsContentEvent event, Emitter emit) async {
    emit(GetAboutUsContentLoadingState());
    try {
      final aboutUsContent = await customizeRepository.getAboutUsContent();
      emit(GetAboutUsContentSuccessfulState(aboutUsContent));
    } catch(e){
      emit(GetAboutUsContentFailedState("Something went wrong fetching the AboutUs content"));
    }
  }

}