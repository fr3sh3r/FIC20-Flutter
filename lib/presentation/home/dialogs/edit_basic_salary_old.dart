import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/basic_salary/update_basic_salary/update_basic_salary_bloc.dart';

class EditBasicSalary extends StatelessWidget {
  final TextEditingController _basicSalaryController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final int basicSalaryId; // ID of the basic salary to be edited

  EditBasicSalary({
    super.key,
    required this.basicSalaryId,
    required double initialBasicSalary,
    required int initialUserId,
  }) {
    _basicSalaryController.text = initialBasicSalary.toString();
    _userIdController.text = initialUserId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Basic Salary'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _basicSalaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Basic Salary'),
            ),
            TextField(
              controller: _userIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final double basicSalary =
                double.tryParse(_basicSalaryController.text) ?? 0.0;
            final int userId = int.tryParse(_userIdController.text) ?? 0;

            // Trigger the Bloc event to update the Basic Salary
            context.read<UpdateBasicSalaryBloc>().add(
                  UpdateBasicSalaryEvent.updateBasicSalary(
                    id: basicSalaryId,
                    userId: userId,
                    basicSalary: basicSalary,
                  ),
                );

            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
