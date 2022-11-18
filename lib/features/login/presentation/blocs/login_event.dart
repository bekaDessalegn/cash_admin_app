import 'package:cash_admin_app/features/login/data/models/login.dart';

abstract class LoginEvent{}

class LoginAdminEvent extends LoginEvent{
  final Login login;
  LoginAdminEvent(this.login);
}

class InitialSendRecoveryEvent extends LoginEvent {}

class SendRecoveryEmailEvent extends LoginEvent{
  final String email;
  SendRecoveryEmailEvent(this.email);
}
//
// class ResetEmailEvent extends LoginEvent{
//   final String recoveryToken, newHashPassword;
//   ResetEmailEvent(this.recoveryToken, this.newHashPassword);
// }