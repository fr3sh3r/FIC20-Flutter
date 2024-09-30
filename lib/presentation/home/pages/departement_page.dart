import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hrm_inventory_pos_app/presentation/home/bloc/department/get_department/get_department_bloc.dart';

import '../../../core/core.dart';
import '../dialogs/add_new_departement.dart';
import '../dialogs/delete_dialog.dart';
import '../dialogs/edit_department.dart';
import '../models/departement_model.dart';
import '../widgets/app_bar_widget.dart';

class DepartementPage extends StatefulWidget {
  const DepartementPage({super.key});

  @override
  State<DepartementPage> createState() => _DepartementPageState();
}

class _DepartementPageState extends State<DepartementPage> {
  bool isEmptyData = false;

  final searchController = TextEditingController();
  late List<DepartementModel> searchResult;

  @override
  void initState() {
    searchResult = departements;
    context
        .read<GetDepartmentBloc>()
        .add(const GetDepartmentEvent.getDepartments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBarWidget(title: 'Departement'),
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
                          searchResult = departements
                              .where((element) => element.departementName
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase()))
                              .toList();
                          setState(() {});
                        },
                      ),
                    ),
                    const SpaceWidth(16.0),
                    Button.filled(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => const AddNewDepartment(),
                      ),
                      label: 'Add New Department',
                      fontSize: 14.0,
                      width: 250.0,
                    ),
                  ],
                ),
              ),
              BlocBuilder<GetDepartmentBloc, GetDepartmentState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SizedBox(),
                    loading: () {
                      return const Padding(
                        padding: EdgeInsets.all(70.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    loaded: (departments) {
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
                                          label: Text('Departement Name')),
                                      const DataColumn(
                                          label: Text('Description')),
                                      const DataColumn(label: Text('')),
                                    ],
                                    rows: departments.isEmpty
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
                                        : departments
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
                                                            DeleteDialog(
                                                                onConfirmTap:
                                                                    () {},
                                                                id: item.id),
                                                      ),
                                                      icon: const Icon(
                                                          Icons.delete_outline),
                                                    ),
                                                    IconButton(
                                                      onPressed: () =>
                                                          showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            EditDepartement(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
