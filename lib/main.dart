import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m_track/constant/colors.dart';
import 'package:m_track/models/user_model.dart';

import 'package:m_track/screens/add_expense_page.dart';
import 'package:m_track/screens/home_screen.dart';
import 'package:m_track/screens/login_screen.dart';
import 'package:m_track/screens/register_page.dart';
import 'package:m_track/screens/splash_screen.dart';
import 'package:m_track/services/auth_service.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await AuthService().openBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomeScreen(),
          '/addExpense': (context) => AddExpensePage(),
        },
      ),
    );
  }
}
