import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../core/core.dart';
import '../../../data/models/response/shift_response_model.dart';
import '../bloc/shift/update_shift/update_shift_bloc.dart';
import '../bloc/shift/get_shift/get_shift_bloc.dart';

import 'dart:developer' as developer;

class EditShift extends StatefulWidget {
  final Shift shift;
  final int shiftId;
  final int companyId;
  final int createdBy;
  final String initialName;
  final TimeOfDay initialClockInTime;
  final TimeOfDay initialClockOutTime;
  final bool initialIsSelfClocking;

  const EditShift({
    required this.shift,
    required this.shiftId,
    required this.companyId,
    required this.createdBy,
    required this.initialName,
    required this.initialClockInTime,
    required this.initialClockOutTime,
    required this.initialIsSelfClocking,
    super.key,
  });

  @override
  State<EditShift> createState() => _EditShiftState();
}

class _EditShiftState extends State<EditShift> {
  late final TextEditingController nameController;
  late final TextEditingController lateMarkAfterController;
  // late final String clockInTime;
  // late final String clockOutTime;
  String clockInTime = '09:00:00'; // Default value
  String clockOutTime = '17:00:00'; // Default value
  bool isSelfClocking = false;

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method
    nameController = TextEditingController(text: widget.shift.name);
    lateMarkAfterController =
        TextEditingController(text: widget.shift.lateMarkAfter.toString());

    // Ensure clockInTime and clockOutTime are non-null
    clockInTime = widget.shift.clockInTime ?? '09:00:00'; // Default value
    clockOutTime = widget.shift.clockOutTime ?? '17:00:00'; // Default value
  }

  @override
  void dispose() {
    nameController.dispose();
    lateMarkAfterController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTimeOfDay(String time) {
    // Check if the time contains AM/PM
    final isPm = time.toLowerCase().contains('pm');
    final isAm = time.toLowerCase().contains('am');

    // Remove any AM/PM suffix and trim whitespace
    time = time.replaceAll(RegExp(r'[aApP][mM]'), '').trim();

    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Convert hour to 24-hour format if needed
    if (isPm && hour != 12) {
      hour += 12;
    } else if (isAm && hour == 12) {
      hour = 0; // Convert 12 AM to 00:00
    }

    // Ensure hour is within the valid range of 0–23
    if (hour >= 24) {
      throw FormatException('Invalid hour: $hour');
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.deviceWidth - 600.0,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Shift',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SpaceHeight(16.0),
                Divider(),
              ],
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: nameController,
                    label: 'Name',
                    hintText: 'Please Enter Name',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SpaceWidth(16.0),
                Flexible(
                  child: CustomTimePicker(
                    initialTime: _parseTimeOfDay(clockInTime),
                    label: 'Clock In Time',
                    hintText: 'Select time',
                    onTimeSelected: (TimeOfDay time) {
                      setState(() {
                        clockInTime = time.format(context);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SpaceHeight(16.0),
            Row(
              children: [
                Flexible(
                  child: CustomTimePicker(
                    initialTime: _parseTimeOfDay(clockOutTime),
                    label: 'Clock Out Time',
                    hintText: 'Select time',
                    onTimeSelected: (TimeOfDay time) {
                      setState(() {
                        clockOutTime = time.format(context);
                      });
                    },
                  ),
                ),
                const SpaceWidth(16.0),
                Flexible(
                  child: CustomTextField(
                    controller: lateMarkAfterController,
                    label: 'Late Mark After',
                    hintText: 'Please Enter Late Mark After',
                    keyboardType: TextInputType.number,
                    suffixIcon: const SizedBox(
                      width: 80.0,
                      child: Center(
                        child: Text('Minute'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SpaceHeight(16.0),
            YesNoToggle(
              label: 'Self Clocking',
              initialValue: isSelfClocking,
              onChanged: (isYesSelected) {
                setState(() {
                  isSelfClocking = isYesSelected;
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              const SpaceHeight(16.0),
              Row(
                children: [
                  const Spacer(),
                  Flexible(
                    child: Button.outlined(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      label: 'Cancel',
                    ),
                  ),
                  const SpaceWidth(16.0),
                  Flexible(
                    child: Button.filled(
                      onPressed: () {
                        _onSavePressed(context);
                      },
                      label: 'Save',
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSavePressed(BuildContext context) async {
    developer.log('Button Pressed:');
    developer.log('Name: ${nameController.text}');
    developer.log('Clock In Time: $clockInTime');
    developer.log('Clock Out Time: $clockOutTime');
    developer.log('Late Mark After: ${lateMarkAfterController.text}');
    developer.log('Is Self Clocking: $isSelfClocking');

    try {
      // Validate input
      if (nameController.text.isNotEmpty &&
          lateMarkAfterController.text.isNotEmpty) {
        // Convert clockInTime and clockOutTime to 24-hour format if necessary
        final parsedClockInTime = _parseTimeOfDay(clockInTime).format(context);
        final parsedClockOutTime =
            _parseTimeOfDay(clockOutTime).format(context);

        // Dispatch event to update the shift
        context.read<UpdateShiftBloc>().add(
              UpdateShiftEvent.updateShift(
                id: widget.shiftId, // Use shiftId from widget
                name: nameController.text,
                clockInTime: parsedClockInTime,
                clockOutTime: parsedClockOutTime,
                lateMarkAfter: int.parse(lateMarkAfterController.text),
                isSelfClocking: isSelfClocking,
              ),
            );

        // Close the dialog
        Navigator.of(context).pop();
      } else {
        // Show error message if inputs are invalid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete all fields'),
          ),
        );
      }
    } catch (e) {
      developer.log('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid input. Please check your entries.'),
        ),
      );
    }
  }
}
