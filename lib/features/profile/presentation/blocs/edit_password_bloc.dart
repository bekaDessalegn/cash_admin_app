import 'dart:io';

import 'package:cash_admin_app/features/profile/data/repositories/profile_repository.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/edit_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPasswordBloc extends Bloc<EditProfileEvent, EditPasswordState>{
  ProfileRepository profileRepository;
  EditPasswordBloc(this.profileRepository) : super(EditPasswordInitialState()){
    on<EditPasswordEvent>(_onEditPasswordEvent);
    on<EditUsernameEvent>(_onEditUsernameEvent);
  }

  void _onEditPasswordEvent(EditPasswordEvent event, Emitter emit) async {
    emit(EditPasswordLoading());
    try {
      await profileRepository.editPassword(
          event.oldPasswordHash, event.newPasswordHash);
      emit(EditPasswordSuccessful());
    } on HttpException{
      emit(EditPasswordFailed("Wrong Password"));
    } on SocketException{
      emit(EditPasswordFailed("Something went wrong please, try again"));
    } on Exception{
      emit(EditPasswordFailed("Something went wrong please, try again"));
    }
  }

  void _onEditUsernameEvent(EditUsernameEvent event, Emitter emit) async {
    emit(EditPasswordLoading());
    try {
      await profileRepository.editUsername(event.newUsername);
      emit(EditPasswordSuccessful());
    } on SocketException {
      emit(EditPasswordFailed("network"));
    } on Exception {
      emit(EditPasswordFailed("api"));
    }
  }

}