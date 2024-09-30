import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/basic_salary/create_basic_salary/create_basic_salary_bloc.dart';

class AddNewBasicSalary extends StatelessWidget {
  final TextEditingController _basicSalaryController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  AddNewBasicSalary({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Basic Salary'),
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

            // Trigger the Bloc event to create a new Basic Salary using the Freezed constructor
            context.read<CreateBasicSalaryBloc>().add(
                  CreateBasicSalaryEvent.createBasicSalary(
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
