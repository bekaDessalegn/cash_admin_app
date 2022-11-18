import 'dart:io';

import 'package:cash_admin_app/features/profile/data/repositories/profile_repository.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitialState()) {
    on<LoadAdminEvent>(_onLoadAdminEvent);
    on<ChangeCommissionRateEvent>(_onChangeCommissionRateEvent);
    on<SignOutEvent>(_onSignOutEvent);
  }

  void _onLoadAdminEvent(LoadAdminEvent event, Emitter emit) async {
    emit(LoadingAdmin());
    try {
      final admin = await profileRepository.getAdmin();
      emit(LoadAdminSuccessful(admin));
    } on SocketException {
      emit(LoadAdminFailed("network"));
    } on Exception {
      emit(LoadAdminFailed("api"));
    }
  }

  void _onChangeCommissionRateEvent(
      ChangeCommissionRateEvent event, Emitter emit) async {
    emit(LoadingAdmin());
    try {
      await profileRepository.changeCommissionRate(event.commissionRate);
      final admin = await profileRepository.getAdmin();
      emit(LoadAdminSuccessful(admin));
    } on SocketException {
      emit(LoadAdminFailed("network"));
    } on Exception {
      emit(LoadAdminFailed("api"));
    }
  }

  void _onSignOutEvent(SignOutEvent event, Emitter emit) async {
    emit(SignOutLoading());
    try {
      await profileRepository.signOut();
      emit(SignOutSuccessful());
    } catch (e) {
      emit(LoadAdminFailed("Something went wrong please, try again"));
    }
  }
}
