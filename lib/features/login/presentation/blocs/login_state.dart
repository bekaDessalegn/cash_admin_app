abstract class LoginState{}

class LoginInitialState extends LoginState{}

class LoginPassedState extends LoginState{}

class LoginLoadingState extends LoginState{}

class LoginFailedState extends LoginState{
  final String errorType;
  LoginFailedState(this.errorType);
}

class SendRecoveryEmailSuccessful extends LoginState {}

class SendRecoveryEmailLoading extends LoginState {}

class SendRecoveryEmailFailed extends LoginState {
  final String errorType;
  SendRecoveryEmailFailed(this.errorType);
}

class ResetEmailSuccessful extends LoginState {}

class ResetEmailLoading extends LoginState {}

class ResetEmailFailed extends LoginState {
  final String errorType;
  ResetEmailFailed(this.errorType);
}