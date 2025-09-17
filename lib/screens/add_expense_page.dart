import 'package:flutter/material.dart';
import 'package:m_track/widgets/appbutton.dart';
import 'package:m_track/widgets/apptext.dart';
import 'package:m_track/widgets/customtextformfiled.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _expenseController = TextEditingController();
  final _expenseKey = GlobalKey<FormState>();
  var expenseCategories = [
    'Housing',
    'Transportation',
    'Food and Groceries',
    'Healthcare',
    'Debt Payments',
    'Entertainment',
    'Personal Care',
    'Clothing and Accessories',
    'Utilities and Bills',
    'Savings and Investments',
    'Education',
    'Travel',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Add Expense")),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Form(
            key: _expenseKey,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      // DropdownButtonFormField(
                      //   initialValue: "Select Category",
                      //   onChanged: (value) {},
                      // ),
                      CustomTextFormField(
                        controller: _descriptionController,
                        hintText: "Description",
                      ),
                      SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _expenseController,
                        hintText: "Enter the amount",
                      ),
                      SizedBox(height: 40),
                      AppButton(
                        width: 230,
                        height: 48,
                        color: Colors.orange,
                        onTap: () {},
                        child: AppText(
                          data: "Add Expense",
                          color: Colors.black,
                        ),
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
