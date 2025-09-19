import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:m_track/constant/colors.dart';
import 'package:m_track/models/user_model.dart';
import 'package:m_track/services/auth_service.dart';
import 'package:m_track/services/fin_service.dart';
import 'package:m_track/widgets/apptext.dart';
import 'package:m_track/widgets/dashboard_widget.dart';
import 'package:m_track/widgets/mydivider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserModel?> _initTotalsFuture = Future.value(null);

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _initTotalsFuture = authService.getCurrentUser().then((user) async {
      if (user != null) {
        await Provider.of<UserService>(
          context,
          listen: false,
        ).initializeTotals(user.id);
      }
      return user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<UserService>(
          builder: (context, userDataService, _) {
            return _buildHomePage(context, userDataService);
          },
        ),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context, UserService? uDataService) {
    final allExpense = uDataService!.totalExpense;
    final allIncome = uDataService.totalIncome;
    return Consumer<AuthService>(
      builder: (context, authServices, child) {
        return FutureBuilder<UserModel?>(
          future: _initTotalsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                final userData = snapshot.data!;
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                AppText(data: "Welcome", color: Colors.white),
                                SizedBox(width: 10),
                                AppText(
                                  data: "${userData.name}",
                                  color: Colors.orange,
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/profilePage');
                            },
                            child: CircleAvatar(
                              child: Text("${userData.name[0].toUpperCase()}"),
                            ),
                          ),
                        ],
                      ),
                      MyDivider(),
                      DashboardItemWidget(
                        onTap1: () {
                          Navigator.pushNamed(
                            context,
                            '/expenseList',
                            arguments: allExpense,
                          );
                        },
                        onTap2: () {
                          Navigator.pushNamed(
                            context,
                            '/incomeList',
                            arguments: allIncome,
                          );
                        },
                        titleOne: "Expenses\n${allExpense}",
                        titleTwo: "Income\n${allIncome}",
                      ),
                      SizedBox(height: 20),
                      DashboardItemWidget(
                        onTap1: () {
                          Navigator.pushNamed(
                            context,
                            '/addExpense',
                            arguments: userData.id,
                          );
                        },
                        onTap2: () {
                          Navigator.pushNamed(
                            context,
                            '/addIncome',
                            arguments: userData.id,
                          );
                        },
                        titleOne: "Add Expense",
                        titleTwo: "Add Income",
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              data: "Icome vs Expense",
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            AspectRatio(
                              aspectRatio: 1.3,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 5,
                                  centerSpaceColor: Colors.transparent,
                                  sections: [
                                    PieChartSectionData(
                                      radius: 50,
                                      color: chartColor1,
                                      value: allExpense,
                                      title: "Expense",
                                      titleStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    PieChartSectionData(
                                      radius: 50,
                                      color: chartColor2,
                                      value: allIncome,
                                      title: "Income",
                                      titleStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: AppText(
                    data: "No user data found",
                    color: Colors.white,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
