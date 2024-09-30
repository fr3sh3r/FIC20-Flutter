import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../core/core.dart';
import '../bloc/holiday/create_holiday/create_holiday_bloc.dart';
import '../bloc/holiday/get_holiday/get_holiday_bloc.dart';

class AddNewHoliday extends StatefulWidget {
  final int companyId; // Add companyId as a parameter
  final int createdBy; // Add createdBy as a parameter

  const AddNewHoliday({
    required this.companyId,
    required this.createdBy,
    super.key,
  });

  @override
  State<AddNewHoliday> createState() => _AddNewHolidayState();
}

class _AddNewHolidayState extends State<AddNewHoliday> {
  late final TextEditingController holidayNameController;
  DateTime? selectedDate;
  bool isWeekend = false;
  final logger = Logger();

  @override
  void initState() {
    holidayNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    holidayNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
                  'Add New Holiday',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(24.0),
                CustomTextField(
                  controller: holidayNameController,
                  label: 'Holiday Name',
                  hintText: 'Please Enter Holiday Name',
                  textInputAction: TextInputAction.next,
                ),
                const SpaceHeight(12.0),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        selectedDate == null
                            ? 'Select Date'
                            : '${selectedDate!.toLocal()}'.split(' ')[0],
                      ),
                    ),
                  ],
                ),
                const SpaceHeight(12.0),
                Row(
                  children: [
                    Checkbox(
                      value: isWeekend,
                      onChanged: (value) {
                        setState(() {
                          isWeekend = value!;
                        });
                      },
                    ),
                    const Text('Is Weekend'),
                  ],
                ),
                const SpaceHeight(24.0),
                Row(
                  children: [
                    Flexible(
                      child: Button.outlined(
                        onPressed: () => context.pop(),
                        label: 'Cancel',
                      ),
                    ),
                    const SpaceWidth(16.0),
                    Flexible(
                      child:
                          BlocConsumer<CreateHolidayBloc, CreateHolidayState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            created: () {
                              context.read<GetHolidayBloc>().add(
                                    const GetHolidayEvent.getHolidays(),
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
                                if (selectedDate != null) {
                                  // Add debug log before dispatching the event
                                  // print(
                                  //     'Creating holiday with: name=${holidayNameController.text}, year=${selectedDate!.year}, month=${selectedDate!.month}, date=${selectedDate!}, isWeekend=$isWeekend, companyId=${widget.companyId}, createdBy=${widget.createdBy}');

                                  // Add debug log before dispatching the event
                                  logger.i(
                                      'Creating holiday with: name=${holidayNameController.text}, year=${selectedDate!.year}, month=${selectedDate!.month}, date=${selectedDate!}, isWeekend=$isWeekend, companyId=${widget.companyId}, createdBy=${widget.createdBy}');

                                  context.read<CreateHolidayBloc>().add(
                                        CreateHolidayEvent.createHoliday(
                                          name: holidayNameController.text,
                                          year: selectedDate!.year,
                                          month: selectedDate!.month,
                                          date: selectedDate!,
                                          isWeekend: isWeekend,
                                          companyId: widget
                                              .companyId, // Pass companyId
                                          createdBy: widget
                                              .createdBy, // Pass createdBy
                                        ),
                                      );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select a date.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
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
