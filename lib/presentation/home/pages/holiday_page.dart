import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/home/dialogs/add_new_holiday.dart';

import '../../../core/core.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../bloc/holiday/delete_holiday/delete_holiday_bloc.dart';
import '../bloc/holiday/get_holiday/get_holiday_bloc.dart';
import '../dialogs/edit_holiday.dart';
import '../dialogs/generic_delete_dialog.dart';
import '../widgets/app_bar_widget.dart';
import 'dart:developer' as developer;

class HolidayPage extends StatefulWidget {
  const HolidayPage({super.key});

  @override
  State<HolidayPage> createState() => _HolidayPageState();
}

class _HolidayPageState extends State<HolidayPage> {
  int companyId = 1; // Replace with actual value
  int createdBy =
      234; // Replace with actual value (e.g., current logged-in user ID)

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    context.read<GetHolidayBloc>().add(const GetHolidayEvent.getHolidays());
  }

  Future<void> _fetchUserData() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      setState(() {
        createdBy =
            authData.user?.id ?? 0; // Use the user ID from the auth data
      });
    } catch (e) {
      developer.log('Error fetching user data: $e', name: 'HolidayPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBarWidget(title: 'Holiday'),
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
                          // Implement search logic if needed
                        },
                      ),
                    ),
                    const SpaceWidth(16.0),
                    Button.filled(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddNewHoliday(
                          companyId: companyId,
                          createdBy: createdBy,
                        ),
                      ),
                      label: 'Add New Holiday',
                      fontSize: 14.0,
                      width: 250.0,
                    ),
                  ],
                ),
              ),
              BlocBuilder<GetHolidayBloc, GetHolidayState>(
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
                    loaded: (holidays) {
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
                                          label: Text('Holiday Name')),
                                      const DataColumn(label: Text('Date')),
                                      const DataColumn(
                                          label: Text('Is Weekend')),
                                      const DataColumn(label: Text('')),
                                    ],
                                    rows: holidays.isEmpty
                                        ? [
                                            const DataRow(
                                              cells: [
                                                DataCell(Row(
                                                  children: [
                                                    Icon(Icons.highlight_off),
                                                    SpaceWidth(4.0),
                                                    Text('Data not found.'),
                                                  ],
                                                )),
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                                DataCell.empty,
                                              ],
                                            ),
                                          ]
                                        : holidays
                                            .map((item) => DataRow(cells: [
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors.black,
                                                    ),
                                                  )),
                                                  DataCell(Text(
                                                    item.date
                                                            ?.toLocal()
                                                            .toString()
                                                            .split(' ')[0] ??
                                                        '',
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
                                                    ),
                                                  )),
                                                  DataCell(Text(
                                                    item.isWeekend == 1
                                                        ? 'Yes'
                                                        : 'No',
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: AppColors.black,
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
                                                            itemName:
                                                                item.name ??
                                                                    'Holiday',
                                                            onConfirmTap:
                                                                () async {
                                                              try {
                                                                // Perform the delete operation
                                                                context
                                                                    .read<
                                                                        DeleteHolidayBloc>()
                                                                    .add(
                                                                      DeleteHolidayEvent
                                                                          .deleteHoliday(
                                                                              item.id!),
                                                                    );
                                                                // Refresh the list after deletion
                                                                context
                                                                    .read<
                                                                        GetHolidayBloc>()
                                                                    .add(const GetHolidayEvent
                                                                        .getHolidays());

                                                                // Return true if the operation was successful
                                                                return true;
                                                              } catch (e) {
                                                                // Handle the error (e.g., log it)
                                                                developer.log(
                                                                    'Error deleting item: $e',
                                                                    name:
                                                                        'HolidayPage');
                                                                // Return false if the operation failed
                                                                return false;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        icon: const Icon(Icons
                                                            .delete_outline),
                                                      ),
                                                      IconButton(
                                                        onPressed: () =>
                                                            showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              EditHoliday(
                                                            item: item,
                                                            holidayId: item.id!,
                                                            companyId:
                                                                companyId,
                                                            createdBy:
                                                                createdBy,
                                                            initialName:
                                                                item.name!,
                                                            initialDate:
                                                                item.date!,
                                                            initialIsWeekend:
                                                                item.isWeekend ==
                                                                    1,
                                                          ),
                                                        ),
                                                        icon: const Icon(Icons
                                                            .edit_outlined),
                                                      ),
                                                    ],
                                                  )),
                                                ]))
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
