import 'package:flutter/material.dart';
import 'package:m_track/models/income_model.dart';
import 'package:m_track/services/auth_service.dart';
import 'package:m_track/services/fin_service.dart';
import 'package:m_track/widgets/apptext.dart';
import 'package:m_track/widgets/mydivider.dart';
import 'package:provider/provider.dart';

class IncomeListPage extends StatefulWidget {
  const IncomeListPage({super.key});

  @override
  State<IncomeListPage> createState() => _IncomeListPageState();
}

class _IncomeListPageState extends State<IncomeListPage> {
  @override
  Widget build(BuildContext context) {
    final double allIncomes =
        ModalRoute.of(context)!.settings.arguments as double;
    final user_service = Provider.of<UserService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: AppText(data: "All Incomes")),
        body: FutureBuilder(
          future: authService.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                final userData = snapshot.data;

                return FutureBuilder<List<IncomeModel>>(
                  future: user_service.getAllIncome(userData!.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        final List<IncomeModel> incList = snapshot.data!;

                        return Container(
                          height: double.infinity,
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              AppText(
                                data: "Total Expense=${allIncomes}",
                                color: Colors.white,
                              ),

                              MyDivider(),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: incList.length,
                                  itemBuilder: (context, index) {
                                    final exp = incList[index];
                                    return Card(
                                      color: Colors.orange,
                                      child: ListTile(
                                        title: AppText(data: exp.category),
                                        subtitle: AppText(
                                          data: exp.amount.toString(),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () async {
                                            final incBox = await user_service
                                                .openIncomeBox();
                                            final keys = incBox.keys.toList();
                                            final incomes = incList[index];
                                            final key = keys[index];
                                            Provider.of<UserService>(
                                              context,
                                              listen: false,
                                            ).deleteIncome(key, incomes.userId);
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
