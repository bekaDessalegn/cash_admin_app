abstract class EditPasswordState {}

class EditPasswordInitialState extends EditPasswordState {}

class EditPasswordSuccessful extends EditPasswordState {}

class EditPasswordFailed extends EditPasswordState {
  final String errorType;
  EditPasswordFailed(this.errorType);
}

class EditPasswordLoading extends EditPasswordState {}