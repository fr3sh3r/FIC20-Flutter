import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../../data/models/response/basic_salary_response_model.dart';
import '../bloc/basic_salary/get_basic_salary/get_basic_salary_bloc.dart';
import '../bloc/basic_salary/update_basic_salary/update_basic_salary_bloc.dart';

import 'dart:developer' as developer;

class EditBasicSalary extends StatefulWidget {
  final BasicSalary item;
  final VoidCallback onConfirmTap;
  const EditBasicSalary({
    super.key,
    required this.item,
    required this.onConfirmTap,
  });

  @override
  State<EditBasicSalary> createState() => _EditBasicSalaryState();
}

class _EditBasicSalaryState extends State<EditBasicSalary> {
  late final TextEditingController basicSalaryController;
  late final TextEditingController userIdController;

  @override
  void initState() {
    basicSalaryController =
        TextEditingController(text: widget.item.basicSalary.toString());
    userIdController =
        TextEditingController(text: widget.item.userId.toString());
    super.initState();
  }

  @override
  void dispose() {
    basicSalaryController.dispose();
    userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 500.0,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Basic Salary',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(24.0),
                CustomTextField(
                  controller: basicSalaryController,
                  label: 'Basic Salary',
                  hintText: 'Please Enter Basic Salary',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const SpaceHeight(12.0),
                CustomTextField(
                  controller: userIdController,
                  label: 'User ID',
                  hintText: 'Please Enter User ID',
                  keyboardType: TextInputType.number,
                ),
                const SpaceHeight(24.0),
                Row(
                  children: [
                    Flexible(
                      child: Button.outlined(
                        onPressed: () => Navigator.of(context).pop(),
                        label: 'Cancel',
                      ),
                    ),
                    const SpaceWidth(16.0),
                    Flexible(
                      child: BlocListener<UpdateBasicSalaryBloc,
                          UpdateBasicSalaryState>(
                        listener: (context, state) {
                          state.maybeMap(
                            orElse: () {},
                            updated: (_) {
                              context.read<GetBasicSalaryBloc>().add(
                                    const GetBasicSalaryEvent.getBasicSalary(),
                                  );
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        child: Button.filled(
                          onPressed: () async {
                            // Perform input validation
                            final double? basicSalary =
                                double.tryParse(basicSalaryController.text);
                            final int? userId =
                                int.tryParse(userIdController.text);

                            // Log the values for debugging
                            developer.log(
                              'LOG=================   UpdateBasicSalary: basicSalary: $basicSalary, userId: $userId',
                              name: 'EditBasicSalary ====',
                            );

                            if (basicSalary == null || userId == null) {
                              // Show an error if inputs are invalid
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please enter valid values for Basic Salary and User ID.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              return;
                            }

                            // Proceed with updating the basic salary
                            context.read<UpdateBasicSalaryBloc>().add(
                                  UpdateBasicSalaryEvent.updateBasicSalary(
                                    id: widget.item.id!,
                                    userId: userId,
                                    basicSalary: basicSalary,
                                  ),
                                );
                          },
                          label: 'Update',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
