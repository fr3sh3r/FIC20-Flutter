import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/home/bloc/basic_salary/create_basic_salary/create_basic_salary_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/home/bloc/basic_salary/get_basic_salary/get_basic_salary_bloc.dart';
import '../../../core/core.dart';

class AddNewBasicSalary extends StatefulWidget {
  final VoidCallback onConfirmTap;
  const AddNewBasicSalary({super.key, required this.onConfirmTap});

  @override
  State<AddNewBasicSalary> createState() => _AddNewBasicSalaryState();
}

class _AddNewBasicSalaryState extends State<AddNewBasicSalary> {
  late final TextEditingController basicSalaryNameController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    basicSalaryNameController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    basicSalaryNameController.dispose();
    descriptionController.dispose();
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
                  'Add New BasicSalary',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(24.0),
                CustomTextField(
                  controller: basicSalaryNameController,
                  label: 'Basic Salary',
                  hintText: 'Please Enter Basic Salary',
                  textInputAction: TextInputAction.next,
                ),
                const SpaceHeight(12.0),
                CustomTextField(
                  controller: descriptionController,
                  label: 'User ID',
                  hintText: 'Please Enter User UD',
                  maxLines: 5,
                ),
                const SpaceHeight(24.0),
                Row(
                  children: [
                    Flexible(
                        child: Button.outlined(
                      onPressed: () => context.pop(),
                      label: 'Cancel',
                    )),
                    const SpaceWidth(16.0),
                    Flexible(
                      child: BlocConsumer<CreateBasicSalaryBloc,
                          CreateBasicSalaryState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            orElse: () {},
                            created: () {
                              context.read<GetBasicSalaryBloc>().add(
                                    const GetBasicSalaryEvent.getBasicSalary(),
                                  );
                              context.pop();
                            },
                            error: (message) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          );
                        },
                        builder: (context, state) {
                          return state.maybeWhen(orElse: () {
                            return Button.filled(
                              onPressed: () {
                                // Try parsing basicSalary to a double and userId to an int
                                double? parsedBasicSalary;
                                int? parsedUserId;

                                try {
                                  parsedBasicSalary = double.parse(
                                      basicSalaryNameController.text);
                                } catch (e) {
                                  // Handle error if the input cannot be parsed to double
                                  // e.g., show a dialog or snackbar to inform the user
                                }

                                try {
                                  parsedUserId =
                                      int.parse(descriptionController.text);
                                } catch (e) {
                                  // Handle error if the input cannot be parsed to int
                                  // e.g., show a dialog or snackbar to inform the user
                                }

                                // Check if parsing was successful
                                if (parsedBasicSalary != null &&
                                    parsedUserId != null) {
                                  context.read<CreateBasicSalaryBloc>().add(
                                        CreateBasicSalaryEvent
                                            .createBasicSalary(
                                          basicSalary: parsedBasicSalary,
                                          userId: parsedUserId,
                                        ),
                                      );
                                } else {
                                  // Show an error message if parsing failed
                                }
                              },
                              label: 'Create',
                            );
                          }, loading: () {
                            return const Center(
                                child: CircularProgressIndicator());
                          });
                        },
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
