import 'package:flutter/material.dart';
import 'package:m_track/models/expense_model.dart';
import 'package:m_track/services/auth_service.dart';
import 'package:m_track/services/fin_service.dart';
import 'package:m_track/widgets/apptext.dart';
import 'package:m_track/widgets/mydivider.dart';
import 'package:provider/provider.dart';

class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  @override
  Widget build(BuildContext context) {
    final double allExpense =
        ModalRoute.of(context)!.settings.arguments as double;
    final user_service = Provider.of<UserService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: AppText(data: "All text")),
        body: FutureBuilder(
          future: authService.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                final userData = snapshot.data;

                return FutureBuilder<List<ExpenseModel>>(
                  future: user_service.getAllExpense(userData!.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        final List<ExpenseModel> expList = snapshot.data!;

                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              AppText(
                                data: "Total Expense=${allExpense}",
                                color: Colors.white,
                              ),

                              MyDivider(),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: expList.length,
                                  itemBuilder: (context, index) {
                                    final exp = expList[index];
                                    return Card(
                                      color: Colors.orange,
                                      child: ListTile(
                                        title: AppText(data: exp.category),
                                        subtitle: AppText(
                                          data: exp.amount.toString(),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () async {
                                            final expBox = await user_service
                                                .openExpenseBox();
                                            final keys = expBox.keys.toList();
                                            final expensess = expList[index];
                                            final key = keys[index];
                                            Provider.of<UserService>(
                                              context,
                                              listen: false,
                                            ).deleteExpense(
                                              key,
                                              expensess.userId,
                                            );
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return Center(child: Text('No data found'));
                  },
                );
              } else {
                // Handle the case when there is no data or an error
                return Center(child: Text('No data found'));
              }
            }
          },
        ),
      ),
    );
  }
}
