import '../model/user_model.dart';

abstract class UserListEvent {}

class AddUser extends UserListEvent {
  final User user;

  AddUser(this.user);
}

class UpdateUser extends UserListEvent {
  final User user;

  UpdateUser(this.user);
}

class DeleteUser extends UserListEvent {
  final User user;

  DeleteUser(this.user);
}
