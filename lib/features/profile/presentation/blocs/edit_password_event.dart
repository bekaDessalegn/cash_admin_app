abstract class EditProfileEvent {}

class EditPasswordEvent extends EditProfileEvent{
  String oldPasswordHash, newPasswordHash;
  EditPasswordEvent(this.oldPasswordHash, this.newPasswordHash);
}

class EditUsernameEvent extends EditProfileEvent{
  String newUsername;
  EditUsernameEvent(this.newUsername);
}