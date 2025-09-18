import 'package:flutter/material.dart';
import 'package:m_track/constant/colors.dart';
import 'package:m_track/models/income_model.dart';
import 'package:m_track/services/fin_service.dart';
import 'package:m_track/widgets/appbutton.dart';
import 'package:m_track/widgets/apptext.dart';
import 'package:m_track/widgets/customtextformfiled.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddIncomePage extends StatefulWidget {
  final uid;
  const AddIncomePage({super.key, this.uid});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  String? incCategory;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _incomeController = TextEditingController();

  var incomeCategories = [
    'Salary/Wages',
    'Freelance/Consulting',
    'Investment Income',
    'Business Income',
    'Side Hustle',
    'Pension/Retirement',
    'Alimony/Child Support',
    'Gifts/Inheritance',
    'Royalties',
    'Savings Withdrawal',
    'Bonus/Incentives',
    'Commissions',
    'Grants/Scholarships',
    'Rental Income',
    'Dividends',
  ];

  final _incomeKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService?>(context);
    final String currentUid =
        ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: AppText(data: "Add Income")),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Form(
            key: _incomeKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButtonFormField(
                        dropdownColor: scaffoldBackgroundColor,
                        style: TextStyle(color: Colors.white),
                        initialValue: incCategory,
                        hint: AppText(
                          data: "Select Category",
                          color: Colors.white,
                        ),
                        items: incomeCategories
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: AppText(data: item),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            incCategory = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "select a category";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _descriptionController,
                        hintText: "Description",
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _incomeController,
                        hintText: "Enter the amount",
                      ),
                      SizedBox(height: 40),
                      AppButton(
                        width: 230,
                        height: 48,
                        color: Colors.orange,
                        onTap: () {
                          var user_id = Uuid().v1();
                          if (_incomeKey.currentState!.validate()) {
                            IncomeModel exp = IncomeModel(
                              id: user_id,
                              userId: currentUid,
                              amount: double.parse(_incomeController.text),
                              description: _descriptionController.text,
                              category: incCategory.toString(),
                              createdAt: DateTime.now(),
                            );
                            userService!.addIncome(exp);
                            Navigator.pop(context);
                          }
                        },
                        child: AppText(data: "Add Income", color: Colors.black),
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
