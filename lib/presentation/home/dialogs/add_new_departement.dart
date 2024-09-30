import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../bloc/department/create_department/create_department_bloc.dart';
import '../bloc/department/get_department/get_department_bloc.dart';

class AddNewDepartment extends StatefulWidget {
  const AddNewDepartment({
    super.key,
  });

  @override
  State<AddNewDepartment> createState() => _AddNewDepartmentState();
}

class _AddNewDepartmentState extends State<AddNewDepartment> {
  late final TextEditingController departmentNameController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    departmentNameController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    departmentNameController.dispose();
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
                  'Add New Department',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(24.0),
                CustomTextField(
                  controller: departmentNameController,
                  label: 'Name',
                  hintText: 'Please Enter Name',
                  textInputAction: TextInputAction.next,
                ),
                const SpaceHeight(12.0),
                CustomTextField(
                  controller: descriptionController,
                  label: 'Description',
                  hintText: 'Please Enter Description',
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
                      child: BlocConsumer<CreateDepartmentBloc,
                          CreateDepartmentState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            created: () {
                              context.read<GetDepartmentBloc>().add(
                                    const GetDepartmentEvent.getDepartments(),
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
                            orElse: () {},
                          );
                        },
                        builder: (context, state) {
                          return state.maybeWhen(orElse: () {
                            return Button.filled(
                              onPressed: () {
                                context.read<CreateDepartmentBloc>().add(
                                      CreateDepartmentEvent.createDepartment(
                                        name: departmentNameController.text,
                                        description: descriptionController.text,
                                      ),
                                    );
                              },
                              label: 'Create',
                            );
                          }, loading: () {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
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
