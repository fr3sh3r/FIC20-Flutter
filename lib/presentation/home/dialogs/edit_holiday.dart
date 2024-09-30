import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../core/core.dart';
import '../../../data/models/response/holiday_response_model.dart';
import '../bloc/holiday/update_holiday/update_holiday_bloc.dart'; // Assuming you have an UpdateHolidayBloc
import '../bloc/holiday/get_holiday/get_holiday_bloc.dart';

class EditHoliday extends StatefulWidget {
  final Holiday item; //include this parameter in the consructor
  final int holidayId; // Add holidayId as a parameter
  final int companyId; // Add companyId as a parameter
  final int createdBy; // Add createdBy as a parameter
  final String initialName; // Initial holiday name
  final DateTime initialDate; // Initial holiday date
  final bool initialIsWeekend; // Initial weekend status

  const EditHoliday({
    required this.item, // Ensure the item parameter is required
    required this.holidayId,
    required this.companyId,
    required this.createdBy,
    required this.initialName,
    required this.initialDate,
    required this.initialIsWeekend,
    super.key,
  });

  @override
  State<EditHoliday> createState() => _EditHolidayState();
}

class _EditHolidayState extends State<EditHoliday> {
  late final TextEditingController holidayNameController;
  DateTime? selectedDate;
  bool isWeekend = false;
  final logger = Logger();

  @override
  void initState() {
    holidayNameController = TextEditingController(text: widget.initialName);
    selectedDate = widget.initialDate;
    isWeekend = widget.initialIsWeekend;
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
      initialDate: selectedDate ?? DateTime.now(),
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
                  'Edit Holiday',
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
                          BlocConsumer<UpdateHolidayBloc, UpdateHolidayState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            updated: () {
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
                                  //     'Editing holiday with: id=${widget.holidayId}, name=${holidayNameController.text}, year=${selectedDate!.year}, month=${selectedDate!.month}, date=${selectedDate!}, isWeekend=$isWeekend, companyId=${widget.companyId}, createdBy=${widget.createdBy}');

                                  logger.i(
                                      'Creating holiday with: name=${holidayNameController.text}, year=${selectedDate!.year}, month=${selectedDate!.month}, date=${selectedDate!}, isWeekend=$isWeekend, companyId=${widget.companyId}, createdBy=${widget.createdBy}');

                                  context.read<UpdateHolidayBloc>().add(
                                        UpdateHolidayEvent.updateHoliday(
                                          id: widget.holidayId,
                                          name: holidayNameController.text,
                                          year: selectedDate!.year,
                                          month: selectedDate!.month,
                                          date: selectedDate!,
                                          isWeekend: isWeekend,
                                          companyId: widget.companyId,
                                          createdBy: widget.createdBy,
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
                              label: 'Save',
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
