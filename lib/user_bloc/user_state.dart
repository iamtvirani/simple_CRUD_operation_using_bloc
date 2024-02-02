import '../model/user_model.dart';

abstract class UserListState {
  List<User> users;

  UserListState({required this.users});
}

class UserInitial extends UserListState {
  UserInitial({required List<User> users}) : super(users: users);
}

class UserListUpdated extends UserListState {
  UserListUpdated({required List<User> users}) : super(users: users);
}
