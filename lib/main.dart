// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_bloc_demo/model/user_model.dart';
import 'package:simple_bloc_demo/user_bloc/user_bloc.dart';
import 'package:simple_bloc_demo/user_bloc/user_event.dart';
import 'package:simple_bloc_demo/user_bloc/user_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter BLoC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => UserListBloc())],
        // Trigger data fetching on app startup
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userListBloc = BlocProvider.of<UserListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('BLoC Demo'),
      ),
      floatingActionButton: ElevatedButton(
          child: Text('Add user'),
          onPressed: () {
            final state = UserListBloc().state;
            final id = (state.users.length + 1).toString();
            showBottomSheet(
                context: context,
                id: id,
                isEdit: false,
                userListBloc: userListBloc);
          }),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          if (state is UserListUpdated && state.users.isNotEmpty) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.users[index].name),
                  subtitle: Text(state.users[index].email),
                  trailing: Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          name.text = state.users[index].name;
                          name.text = state.users[index].email;
                          showBottomSheet(
                              id: state.users[index].id,
                              context: context,
                              isEdit: true,
                              userListBloc: userListBloc);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                          onPressed: () {
                            userListBloc.add(DeleteUser(state.users[index]));
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ))
                    ],
                  ),
                );
              },
            );
          } else {
            return SizedBox(
              width: double.infinity,
              child: Center(
                child: Text('No user found'),
              ),
            );
          }
        },
      ),
    );
  }

  void showBottomSheet(
          {required BuildContext context,
          bool isEdit = false,
          required String id,
          required userListBloc}) =>
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  buildWidgetField(hintText: '', controller: name),
                  buildWidgetField(hintText: '', controller: email),
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: ElevatedButton(
                        onPressed: () {
                          final user =
                              User(name.text, id.toString(), email.text);
                          if (isEdit) {
                            userListBloc.add(UpdateUser(user));
                          } else {
                            userListBloc.add(AddUser(user));
                          }
                          Navigator.pop(context);
                        },
                        child: Text(isEdit ? 'Update' : "Add")),
                  )
                ],
              ),
            );
          });

  Widget buildWidgetField(
          {required TextEditingController controller,
          required String hintText}) =>
      Padding(
        padding: EdgeInsets.all(12.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        ),
      );
}
