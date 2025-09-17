import 'package:flutter/material.dart';
import 'package:m_track/models/user_model.dart';
import 'package:m_track/services/auth_service.dart';
import 'package:m_track/widgets/appbutton.dart';
import 'package:m_track/widgets/apptext.dart';
import 'package:m_track/widgets/customtextformfiled.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();

  final _registerKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final authservice = Provider.of<AuthService>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.0),
          height: double.infinity,
          width: double.infinity,
          child: Form(
            key: _registerKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        data: "Create Account",
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(height: 40),
                      CustomTextFormField(
                        controller: _emailcontroller,
                        hintText: "Email",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        obscureText: true,
                        controller: _passwordcontroller,
                        hintText: "Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _namecontroller,
                        hintText: "Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _phonecontroller,
                        hintText: "Phone",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter phone number";
                          } else if (value.length < 10) {
                            return "Phone number must be at least 10 digits";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40),
                      AppButton(
                        height: 48,
                        width: 250,
                        color: Colors.orange,
                        onTap: () async {
                          var uuid = Uuid().v1();
                          if (_registerKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                            UserModel user = UserModel(
                              id: uuid,
                              email: _emailcontroller.text.trim(),
                              password: _passwordcontroller.text.trim(),
                              name: _namecontroller.text,
                              phone: _phonecontroller.text,
                              status: 1,
                            );
                            final res = await authservice.registerUser(user);
                            Navigator.pop(context);
                            if (res == true) {
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Registration failed. Please try again.',
                                ),
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            }
                          }
                        },
                        child: AppText(data: "Register", color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            data: "Already have an account?",
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: AppText(data: "Login", color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
