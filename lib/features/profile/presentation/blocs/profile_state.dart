import 'package:cash_admin_app/features/profile/data/models/admin.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class LoadAdminSuccessful extends ProfileState {
  final Admin admin;
  LoadAdminSuccessful(this.admin);
}

class LoadAdminFailed extends ProfileState {
  final String errorType;
  LoadAdminFailed(this.errorType);
}

class LoadingAdmin extends ProfileState {}

class EditUsernameSuccessful extends ProfileState {}

class EditUsernameFailed extends ProfileState {
  final String errorType;
  EditUsernameFailed(this.errorType);
}

class EditUsernameLoading extends ProfileState {}

class SignOutSuccessful extends ProfileState {}

class SignOutLoading extends ProfileState {}

class SignOutFailed extends ProfileState {}