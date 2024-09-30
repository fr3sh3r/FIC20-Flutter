import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../bloc/shift/delete_shift/delete_shift_bloc.dart';
import '../bloc/shift/get_shift/get_shift_bloc.dart';
import '../dialogs/add_new_shift.dart';
import '../dialogs/generic_delete_dialog.dart';
import '../widgets/app_bar_widget.dart';
import 'dart:developer' as developer;

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    context.read<GetShiftBloc>().add(const GetShiftEvent.getShift());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBarWidget(title: 'Shift'),
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
                          // Implement search functionality here if needed
                        },
                      ),
                    ),
                    const SpaceWidth(16.0),
                    Button.filled(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => const AddNewShift(),
                      ),
                      label: 'Add New Shift',
                      fontSize: 14.0,
                      width: 250.0,
                    ),
                  ],
                ),
              ),
              BlocBuilder<GetShiftBloc, GetShiftState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    loaded: (shifts) {
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
                                      const DataColumn(label: Text('Name')),
                                      const DataColumn(
                                          label: Text('Clock In Time')),
                                      const DataColumn(
                                          label: Text('Clock Out Time')),
                                      const DataColumn(
                                          label: Text('Self Clocking')),
                                      const DataColumn(
                                          label: Text('Late Mark After')),
                                      const DataColumn(label: Text('')),
                                    ],
                                    rows: shifts.isEmpty
                                        ? [
                                            const DataRow(
                                              cells: [
                                                DataCell(Row(
                                                  children: [
                                                    Icon(Icons.highlight_off),
                                                    SpaceWidth(4.0),
                                                    Text('Data not found..'),
                                                  ],
                                                )),
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                              ],
                                            ),
                                          ]
                                        : shifts
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
                                                DataCell(Text(item
                                                        .clockInTime ??
                                                    'N/A')), // Provide fallback 'N/A' if null
                                                DataCell(Text(
                                                    item.clockOutTime ??
                                                        'N/A')),
                                                DataCell(Text(
                                                    '${item.lateMarkAfter ?? 0} Minutes')), // Fallback for lateMarkAfter
                                                DataCell(Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 4.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    border: Border.all(
                                                        color:
                                                            AppColors.stroke),
                                                  ),
                                                  child: const Row(
                                                    children: [
                                                      // Badge(
                                                      //   backgroundColor: item
                                                      //           .isSelfClocking
                                                      //       ? AppColors.green
                                                      //       : AppColors.red,
                                                      // ),
                                                      SpaceWidth(8.0),
                                                      // Text(item.selfClocking),
                                                    ],
                                                  ),
                                                )),
                                                DataCell(Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () =>
                                                          showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            GenericDeleteDialog(
                                                          itemName: item.name ??
                                                              'Shift',
                                                          onConfirmTap:
                                                              () async {
                                                            try {
                                                              // Perform the delete operation
                                                              context
                                                                  .read<
                                                                      DeleteShiftBloc>()
                                                                  .add(
                                                                    DeleteShiftEvent.deleteShift(
                                                                        id: item
                                                                            .id!),
                                                                  );
                                                              // Refresh the list after deletion
                                                              context
                                                                  .read<
                                                                      GetShiftBloc>()
                                                                  .add(const GetShiftEvent
                                                                      .getShift());

                                                              // Return true if the operation was successful
                                                              return true;
                                                            } catch (e) {
                                                              // Handle the error (e.g., log it)
                                                              developer.log(
                                                                'Error deleting item: $e',
                                                                name:
                                                                    'ShiftPage',
                                                              );
                                                              // Return false if the operation failed
                                                              return false;
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      icon: const Icon(
                                                          Icons.delete_outline),
                                                    ),
                                                    // IconButton(
                                                    //   onPressed: () =>
                                                    //       showDialog(
                                                    //     context: context,
                                                    //     builder: (context) =>
                                                    //         EditShift(
                                                    //       item: item,
                                                    //       onConfirmTap: () {},
                                                    //     ),
                                                    //   ),
                                                    //   icon: const Icon(
                                                    //       Icons.edit_outlined),
                                                    // ),
                                                  ],
                                                )),
                                              ]),
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
                    orElse: () => const SizedBox(), // Handle other states here
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
