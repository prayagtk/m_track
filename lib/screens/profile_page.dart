import 'package:flutter/material.dart';

import 'package:m_track/services/auth_service.dart';
import 'package:m_track/widgets/appbutton.dart';

//import 'package:m_track/services/auth_service.dart';

import 'package:m_track/widgets/apptext.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authservice = Provider.of<AuthService>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: AppText(data: "Profile Page")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                height: 48,
                width: 230,
                color: Colors.orange,
                onTap: () async {
                  final data = await authservice.logOut();

                  if (data == true) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                },
                child: AppText(data: "Logout"),
              ),
              SizedBox(height: 20),
              AppText(data: "Profile page", color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
