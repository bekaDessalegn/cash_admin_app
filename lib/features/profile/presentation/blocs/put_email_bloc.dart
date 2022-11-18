import 'dart:io';

import 'package:cash_admin_app/features/profile/data/repositories/profile_repository.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/put_email_event.dart';
import 'package:cash_admin_app/features/profile/presentation/blocs/put_email_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PutEmailBloc extends Bloc<EmailEvent, PutEmailState>{
  ProfileRepository profileRepository;
  PutEmailBloc(this.profileRepository) : super(PutEmailInitialState()){
    on<InitialPutEmailEvent>(_onInitialPutEmailEvent);
    on<PutEmailEvent>(_onPutEmailEvent);
    on<VerifyEmailEvent>(_onVerifyEmailEvent);
  }

  void _onInitialPutEmailEvent(InitialPutEmailEvent event, Emitter emit) async {
    emit(PutEmailInitialState());
  }

  void _onPutEmailEvent(PutEmailEvent event, Emitter emit) async {
    emit(PutEmailLoading());
    try {
      await profileRepository.putEmail(event.email);
      emit(PutEmailSuccessful());
    } on HttpException{
      emit(PutEmailFailed("Invalid Email address"));
    } on SocketException{
      emit(PutEmailFailed("Something went wrong please, try again"));
    } on Exception{
      emit(PutEmailFailed("Something went wrong please, try again"));
    }
  }

  void _onVerifyEmailEvent(VerifyEmailEvent event, Emitter emit) async {
    emit(VerifyEmailLoading());
    try {
      await profileRepository.verifyEmail(event.verificationCode);
      emit(VerifyEmailSuccessful());
    } on HttpException{
      emit(VerifyEmailFailed("Invalid Verification Code"));
    } on SocketException{
      emit(VerifyEmailFailed("Something went wrong please, try again"));
    } on Exception{
      emit(VerifyEmailFailed("Something went wrong please, try again"));
    }
  }
}