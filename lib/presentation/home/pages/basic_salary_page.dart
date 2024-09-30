import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../bloc/basic_salary/delete_basic_salary/delete_basic_salary_bloc.dart';
import '../bloc/basic_salary/get_basic_salary/get_basic_salary_bloc.dart';
import '../dialogs/add_new_basic_salary.dart';
import '../dialogs/edit_basic_salary.dart';
import '../dialogs/generic_delete_dialog.dart';
import '../widgets/app_bar_widget.dart';
import 'dart:developer' as developer;

class BasicSalaryPage extends StatefulWidget {
  const BasicSalaryPage({super.key});

  @override
  State<BasicSalaryPage> createState() => _BasicSalaryPageState();
}

class _BasicSalaryPageState extends State<BasicSalaryPage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    context
        .read<GetBasicSalaryBloc>()
        .add(const GetBasicSalaryEvent.getBasicSalary());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBarWidget(title: 'BasicSalary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: SearchInput(
                        controller: searchController,
                        hintText: 'Quick search...',
                        onChanged: (value) {
                          // Implement search functionality here if needed
                        },
                      ),
                    ),
                    const SpaceWidth(16.0),
                    Button.filled(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddNewBasicSalary(
                          onConfirmTap: () {},
                        ),
                      ),
                      label: 'Add New BasicSalary',
                      fontSize: 14.0,
                      width: 250.0,
                    ),
                  ],
                ),
              ),
              BlocBuilder<GetBasicSalaryBloc, GetBasicSalaryState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SizedBox(),
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    },
                    loaded: (basicsalaries) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    dataRowMinHeight: 30.0,
                                    dataRowMaxHeight: 60.0,
                                    columns: [
                                      DataColumn(
                                        label: SizedBox(
                                          height: 24.0,
                                          width: 24.0,
                                          child: Checkbox(
                                            value: false,
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ),
                                      const DataColumn(label: Text('User ID')),
                                      const DataColumn(
                                          label: Text('Basic Salary')),
                                      const DataColumn(label: Text('')),
                                    ],
                                    rows: basicsalaries.isEmpty
                                        ? [
                                            const DataRow(
                                              cells: [
                                                DataCell(Row(
                                                  children: [
                                                    Icon(Icons.highlight_off),
                                                    SpaceWidth(4.0),
                                                    Text('Data not found...'),
                                                  ],
                                                )),
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                              ],
                                            ),
                                          ]
                                        : basicsalaries
                                            .map(
                                              (item) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    SizedBox(
                                                      height: 24.0,
                                                      width: 24.0,
                                                      child: Checkbox(
                                                        value: false,
                                                        onChanged: (value) {},
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(Text(
                                                    item.userId.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors.black,
                                                    ),
                                                  )),
                                                  DataCell(Text(
                                                    item.basicSalary ?? '',
                                                  )),
                                                  DataCell(Row(
                                                    children: [
                                                      // Delete Button
                                                      IconButton(
                                                        onPressed: () =>
                                                            showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              GenericDeleteDialog(
                                                            itemName: item
                                                                    .basicSalary ??
                                                                'BasicSalary',
                                                            onConfirmTap:
                                                                () async {
                                                              try {
                                                                if (item.id !=
                                                                    null) {
                                                                  // Perform the delete operation
                                                                  context
                                                                      .read<
                                                                          DeleteBasicSalaryBloc>()
                                                                      .add(
                                                                        DeleteBasicSalaryEvent
                                                                            .deleteBasicSalary(
                                                                          id: item
                                                                              .id!,
                                                                        ),
                                                                      );

                                                                  // Refresh the list after deletion
                                                                  context
                                                                      .read<
                                                                          GetBasicSalaryBloc>()
                                                                      .add(
                                                                        const GetBasicSalaryEvent
                                                                            .getBasicSalary(),
                                                                      );

                                                                  // Return true if the operation was successful
                                                                  return true;
                                                                } else {
                                                                  developer.log(
                                                                      'Error: BasicSalary ID is null',
                                                                      name:
                                                                          'BasicSalaryPage');
                                                                  // Return false if the ID is null
                                                                  return false;
                                                                }
                                                              } catch (e) {
                                                                // Handle the error
                                                                developer.log(
                                                                    'Error deleting item: $e',
                                                                    name:
                                                                        'BasicSalaryPage');
                                                                // Return false if the operation failed
                                                                return false;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        icon: const Icon(Icons
                                                            .delete_outline),
                                                      ),
                                                      // Edit Button
                                                      IconButton(
                                                        onPressed: () =>
                                                            showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              EditBasicSalary(
                                                            item:
                                                                item, // Pass the BasicSalary object
                                                            onConfirmTap:
                                                                () async {
                                                              try {
                                                                // Trigger update operation
                                                                // Example: Call an event from BLoC to update the basic salary
                                                                // context.read<UpdateBasicSalaryBloc>().add(UpdateBasicSalaryEvent.updateBasicSalary(id: item.id, newValues: ...));
                                                              } catch (e) {
                                                                // Handle error
                                                                developer.log(
                                                                  'Error editing item: $e',
                                                                  name:
                                                                      'BasicSalaryPage',
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        icon: const Icon(Icons
                                                            .edit_outlined),
                                                      ),
                                                    ],
                                                  )),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
