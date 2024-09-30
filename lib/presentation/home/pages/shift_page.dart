import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/home/bloc/shift/update_shift/update_shift_bloc.dart';

import '../../../core/core.dart';
import '../bloc/shift/delete_shift/delete_shift_bloc.dart';
import '../bloc/shift/get_shift/get_shift_bloc.dart';
import '../dialogs/add_new_shift.dart';
import '../dialogs/edit_shift.dart';
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

  TimeOfDay? parseTime(String? time) {
    if (time == null || time.isEmpty)
      return null; // Return null if time is null
    final parts = time.split(':');
    if (parts.length != 2) return null; // Ensure it's a valid time string
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    print('Parsed Time - Hour: $hour, Minute: $minute'); // Debugging line
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
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
                      ).then((_) {
                        // After successful creation (assuming AddNewShift returns a value on success)
                        context
                            .read<GetShiftBloc>()
                            .add(const GetShiftEvent.getShift());
                      }),
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
                                      // const DataColumn(
                                      //     label: Text('Self Clocking')),
                                      const DataColumn(
                                          label: Text('Late Mark After')),
                                      const DataColumn(
                                          label: Text('Self Clocking')),
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
                                                  child: Row(
                                                    children: [
                                                      Badge(
                                                        backgroundColor:
                                                            item.isSelfClocking ==
                                                                    true
                                                                ? AppColors
                                                                    .green
                                                                : AppColors.red,
                                                      ),
                                                      const SpaceWidth(8.0),
                                                      Text(
                                                          item.isSelfClocking ==
                                                                  true
                                                              ? 'Yes'
                                                              : 'No'),
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
                                                    IconButton(
                                                      onPressed: () {
                                                        if (item.id != null &&
                                                            item.companyId !=
                                                                null &&
                                                            item.createdBy !=
                                                                null) {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    EditShift(
                                                              shift: item,
                                                              shiftId: item
                                                                  .id!, // Use '!' only if you have ensured item.id is not null
                                                              companyId: item
                                                                  .companyId!,
                                                              createdBy: item
                                                                  .createdBy!,
                                                              initialName: item
                                                                      .name ??
                                                                  '', // Provide fallback value for name
                                                              initialClockInTime:
                                                                  parseTime(item
                                                                          .clockInTime) ??
                                                                      const TimeOfDay(
                                                                          hour:
                                                                              9,
                                                                          minute:
                                                                              0),
                                                              initialClockOutTime: parseTime(item
                                                                      .clockOutTime) ??
                                                                  const TimeOfDay(
                                                                      hour: 17,
                                                                      minute:
                                                                          0),
                                                              initialIsSelfClocking:
                                                                  item.isSelfClocking ??
                                                                      false, // Pass the initial value
                                                            ),
                                                          ).then(
                                                              (updatedShift) {
                                                            if (updatedShift !=
                                                                null) {
                                                              context
                                                                  .read<
                                                                      UpdateShiftBloc>()
                                                                  .add(
                                                                    UpdateShiftEvent
                                                                        .updateShift(
                                                                      id: updatedShift
                                                                          .id!,
                                                                      name: updatedShift
                                                                          .name!,
                                                                      clockInTime:
                                                                          updatedShift
                                                                              .clockInTime!,
                                                                      clockOutTime:
                                                                          updatedShift
                                                                              .clockOutTime!,
                                                                      lateMarkAfter:
                                                                          updatedShift
                                                                              .lateMarkAfter!,
                                                                      isSelfClocking:
                                                                          updatedShift
                                                                              .isSelfClocking!,
                                                                    ),
                                                                  );
                                                              context
                                                                  .read<
                                                                      GetShiftBloc>()
                                                                  .add(const GetShiftEvent
                                                                      .getShift());
                                                            }
                                                          });
                                                        } else {
                                                          // Handle the case where any of the required fields are null
                                                          print(
                                                              'Some required fields are null');
                                                          print(
                                                              'Clock In Time: ${item.clockInTime}');
                                                          print(
                                                              'Clock Out Time: ${item.clockOutTime}');
                                                        }
                                                      },
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
