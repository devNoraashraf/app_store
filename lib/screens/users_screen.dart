import 'package:app_store/models/user_model.dart';
import 'package:app_store/services/api_handler.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: FutureBuilder<List<UserModel>>(
        future: ApiHandler().getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final users = snapshot.data ?? [];

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar ?? ""),
                  onBackgroundImageError: (_, __) =>
                      const Icon(Icons.person, size: 30),
                ),
                title: Text(user.name ?? "Unknown"),
                subtitle: Text(user.email ?? ""),
                trailing: Text(user.role ?? ""),
              );
            },
          );
        },
      ),
    );
  }
}
