import 'dart:io';

import 'package:cash_admin_app/features/login/data/repositories/login_repository.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_event.dart';
import 'package:cash_admin_app/features/login/presentation/blocs/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{

  final LoginRepository loginRepository;
  LoginBloc(this.loginRepository) : super(LoginInitialState()){
    on<LoginAdminEvent>(_onLoginAdminEvent);
    on<InitialSendRecoveryEvent>(_onInitialSendRecoveryEvent);
    on<SendRecoveryEmailEvent>(_onSendRecoveryEmailEvent);
    // on<ResetEmailEvent>(_onResetEmailEvent);
  }

  void _onInitialSendRecoveryEvent(InitialSendRecoveryEvent event, Emitter emit) async {
    emit(LoginInitialState());
  }

  void _onLoginAdminEvent(LoginAdminEvent event, Emitter emit) async{

    emit(LoginLoadingState());

    try{
      await loginRepository.loginAdmin(event.login);
      emit(LoginPassedState());
    } on HttpException{
      emit(LoginFailedState("One of the credentials is wrong"));
    } on SocketException{
      emit(LoginFailedState("Something went wrong please, try again"));
    } on Exception{
      emit(LoginFailedState("Something went wrong please, try again"));
    }
  }

  void _onSendRecoveryEmailEvent(SendRecoveryEmailEvent event, Emitter emit) async {
    emit(SendRecoveryEmailLoading());
    try{
      await loginRepository.sendRecoveryEmail(event.email);
      emit(SendRecoveryEmailSuccessful());
    } on HttpException{
      emit(SendRecoveryEmailFailed("User not found"));
    } on SocketException{
      emit(SendRecoveryEmailFailed("Something went wrong please, try again"));
    } on Exception{
      emit(SendRecoveryEmailFailed("Something went wrong please, try again"));
    }
  }
  //
  // void _onResetEmailEvent(ResetEmailEvent event, Emitter emit) async {
  //   emit(ResetEmailLoading());
  //   await layed(Duration(seconds: 2));
  //   try{
  //     await loginRepository.resetPassword(event.recoveryToken, event.newHashPassword);
  //     emit(ResetEmailSuccessful());
  //   } on HttpException{
  //     emit(ResetEmailFailed("The token has expired"));
  //   } on SocketException{
  //     emit(ResetEmailFailed("Something went wrong please, try again"));
  //   } on Exception{
  //     emit(ResetEmailFailed("Something went wrong please, try again"));
  //   }
  // }
}