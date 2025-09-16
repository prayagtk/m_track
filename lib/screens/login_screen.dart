import 'package:flutter/material.dart';
import 'package:m_track/constant/colors.dart';
import 'package:m_track/widgets/appbutton.dart';
import 'package:m_track/widgets/apptext.dart';
import 'package:m_track/widgets/customtextformfiled.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  final _loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          child: Form(
            key: _loginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    }
                    return null;
                  },
                  controller: _emailcontroller,
                  hintText: "Email",
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: _passwordcontroller,
                  hintText: "Password",
                ),
                SizedBox(height: 40),
                AppButton(
                  height: 48,
                  width: 250,
                  color: Colors.orange,
                  onTap: () {
                    if (_loginKey.currentState!.validate()) {
                      // Process data.
                    }
                  },
                  child: AppText(data: "Login", color: Colors.white),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      data: "Don't have an account?",
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: AppText(data: "Register", color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
