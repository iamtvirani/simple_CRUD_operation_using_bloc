import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_bloc_demo/user_bloc/user_event.dart';
import 'package:simple_bloc_demo/user_bloc/user_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  UserListBloc() : super(UserInitial(users: [])) {
    on<AddUser>(_addUser);
    on<UpdateUser>(_updateUser);
    on<DeleteUser>(_deleteUser);
  }

  void _addUser(AddUser even, Emitter<UserListState> emit) {
    state.users.add(even.user);
    emit(UserListUpdated(users: state.users));
  }

  void _deleteUser(DeleteUser even, Emitter<UserListState> emit) {
    state.users.remove(even.user);
    emit(UserListUpdated(users: state.users));
  }

  void _updateUser(UpdateUser even, Emitter<UserListState> emit) {
    for (int i = 0; i < state.users.length; i++) {
      if (even.user.id == state.users[i].id) {
        state.users[i] = even.user;
      }
    }
    emit(UserListUpdated(users: state.users));
  }
}
