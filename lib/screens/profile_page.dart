import 'package:flutter/material.dart';

import 'package:m_track/services/auth_service.dart';

import 'package:m_track/widgets/appbutton.dart';

import 'package:m_track/widgets/apptext.dart';
import 'package:m_track/widgets/mydivider.dart';
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
        body: FutureBuilder(
          future: authservice.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: AppText(data: "No user found"));
            }
            final user = snapshot.data!;
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 40),
                      CircleAvatar(
                        backgroundColor: Colors.deepOrangeAccent,
                        radius: 40,
                        child: AppText(
                          data: '${user.name[0].toUpperCase()}',
                          size: 40,
                        ),
                      ),
                      SizedBox(width: 50),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(data: "${user.name}", color: Colors.white),
                          AppText(
                            data: "${user.phone.toString()}",
                            color: Colors.white,
                          ),
                          AppText(data: "${user.email}", color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                  MyDivider(),
                  SizedBox(height: 20),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
