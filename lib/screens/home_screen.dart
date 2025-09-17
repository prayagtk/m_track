import 'package:flutter/material.dart';
import 'package:m_track/models/user_model.dart';
import 'package:m_track/services/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authservice = Provider.of<AuthService>(context);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<UserModel?>(
          future: authservice.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                return Center(child: Text("Welcome ${user.name}"));
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
