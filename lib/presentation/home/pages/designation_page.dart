import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../bloc/designation/delete_designation/delete_designation_bloc.dart';
import '../bloc/designation/get_designation/get_designation_bloc.dart';
import '../dialogs/add_new_designation.dart';
import '../dialogs/edit_designation.dart';
import '../dialogs/generic_delete_dialog.dart';
import '../widgets/app_bar_widget.dart';
import 'dart:developer' as developer;

class DesignationPage extends StatefulWidget {
  const DesignationPage({super.key});

  @override
  State<DesignationPage> createState() => _DesignationPageState();
}

class _DesignationPageState extends State<DesignationPage> {
  bool isEmptyData = false;

  final searchController = TextEditingController();
  // late List<DesignationModel> searchResult;

  @override
  void initState() {
    context
        .read<GetDesignationBloc>()
        .add(const GetDesignationEvent.getDesignations());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBarWidget(title: 'Designation'),
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
                        hintText: 'Quick search..',
                        onChanged: (value) {
                          // searchResult = designations
                          //     .where((element) => element.designationName
                          //         .toLowerCase()
                          //         .contains(
                          //             searchController.text.toLowerCase()))
                          //     .toList();
                          // setState(() {});
                        },
                      ),
                    ),
                    const SpaceWidth(16.0),
                    Button.filled(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddNewDesignation(
                          onConfirmTap: () {},
                        ),
                      ),
                      label: 'Add New Designation',
                      fontSize: 14.0,
                      width: 250.0,
                    ),
                  ],
                ),
              ),
              BlocBuilder<GetDesignationBloc, GetDesignationState>(
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
                    loaded: (designations) {
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
                                      const DataColumn(
                                          label: Text('Designation Name')),
                                      const DataColumn(
                                          label: Text('Description')),
                                      const DataColumn(label: Text('')),
                                    ],
                                    rows: designations.isEmpty
                                        ? [
                                            const DataRow(
                                              cells: [
                                                DataCell(Row(
                                                  children: [
                                                    Icon(Icons.highlight_off),
                                                    SpaceWidth(4.0),
                                                    Text(
                                                        'Data tidak ditemukan..'),
                                                  ],
                                                )),
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                              ],
                                            ),
                                          ]
                                        : designations
                                            .map(
                                              (item) => DataRow(cells: [
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
                                                  item.name!,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.black,
                                                  ),
                                                )),
                                                DataCell(Text(
                                                    item.description ?? '')),
                                                DataCell(Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () =>
                                                          showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            GenericDeleteDialog(
                                                          itemName: item.name ??
                                                              'Designation',
                                                          onConfirmTap:
                                                              () async {
                                                            try {
                                                              // Perform the delete operation
                                                              context
                                                                  .read<
                                                                      DeleteDesignationBloc>()
                                                                  .add(
                                                                    DeleteDesignationEvent
                                                                        .deleteDesignation(
                                                                            item.id!),
                                                                  );
                                                              // Refresh the list after deletion
                                                              context
                                                                  .read<
                                                                      GetDesignationBloc>()
                                                                  .add(const GetDesignationEvent
                                                                      .getDesignations());

                                                              // Return true if the operation was successful
                                                              return true;
                                                            } catch (e) {
                                                              // Handle the error (e.g., log it)
                                                              developer.log(
                                                                  'Error deleting item: $e',
                                                                  name:
                                                                      'DesignationPage');
                                                              // Return false if the operation failed
                                                              return false;
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      icon: const Icon(
                                                          Icons.delete_outline),
                                                    ),
                                                    IconButton(
                                                      onPressed: () =>
                                                          showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            EditDesignation(
                                                          item: item,
                                                          onConfirmTap: () {},
                                                        ),
                                                      ),
                                                      icon: const Icon(
                                                          Icons.edit_outlined),
                                                    ),
                                                  ],
                                                )),
                                              ]),
                                            )
                                            .toList(),
                                  ),
                                ),
                              ),
                              // if (searchResult.isNotEmpty)
                              //   const Padding(
                              //     padding: EdgeInsets.all(16.0),
                              //     child: PaginationWidget(),
                              //   ),
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
