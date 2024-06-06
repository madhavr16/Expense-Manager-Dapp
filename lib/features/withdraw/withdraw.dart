import 'package:expense_manager_dapp/features/dashboard/bloc/dashboardbloc_bloc.dart';
import 'package:expense_manager_dapp/models/transaction_model.dart';
import 'package:expense_manager_dapp/utils/colors.dart';
import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  final DashboardblocBloc dashboardblocBloc;
  const WithdrawPage({
    super.key,
    required this.dashboardblocBloc,
  });

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.redAccent,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Text(
              'Withdraw Details',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'Enter the Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                hintText: 'Enter the amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                hintText: 'Enter the Reason',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              )
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                 widget.dashboardblocBloc.add(DashboardWithdrawEvent(
                  transactionModel: TransactionModel(
                    user: _addressController.text,
                    amount: int.parse(_amountController.text),
                    reason: _reasonController.text,
                    time: DateTime.now()
                  ),
                ));
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red,
                ),
                child: const Center(
                  child: Text('- WITHDRAW',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}