import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import '../../../core/core.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../data/models/response/shift_response_model.dart';
import '../bloc/shift/update_shift/update_shift_bloc.dart';

class EditShift extends StatefulWidget {
  final Shift shift;
  const EditShift({required this.shift, super.key});

  @override
  State<EditShift> createState() => _EditShiftState();
}

class _EditShiftState extends State<EditShift> {
  late final TextEditingController nameController;
  late final TextEditingController lateMarkAfterController;
  TimeOfDay? clockInTime;
  TimeOfDay? clockOutTime;
  late bool isSelfClocking;

  @override
  void initState() {
    super.initState();

    // Initialize with existing shift data
    nameController = TextEditingController(text: widget.shift.name);
    lateMarkAfterController = TextEditingController(
      text: widget.shift.lateMarkAfter?.toString() ?? '',
    );
    clockInTime = TimeOfDay(
      hour: int.parse(widget.shift.clockInTime.split(':')[0]),
      minute: int.parse(widget.shift.clockInTime.split(':')[1]),
    );
    clockOutTime = TimeOfDay(
      hour: int.parse(widget.shift.clockOutTime.split(':')[0]),
      minute: int.parse(widget.shift.clockOutTime.split(':')[1]),
    );
    isSelfClocking = widget.shift.isSelfClocking ?? false;
  }

  @override
  void dispose() {
    nameController.dispose();
    lateMarkAfterController.dispose();
    super.dispose();
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
                    initialTime: clockInTime,
                    label: 'Clock In Time',
                    hintText: 'Select time',
                    onTimeSelected: (TimeOfDay time) {
                      setState(() {
                        clockInTime = time;
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
                    initialTime: clockOutTime,
                    label: 'Clock Out Time',
                    hintText: 'Select time',
                    onTimeSelected: (TimeOfDay time) {
                      setState(() {
                        clockOutTime = time;
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
                        _onEditPressed(context); // Function to update shift
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

  Future<void> _onEditPressed(BuildContext context) async {
    // Log the input values before validation
    developer.log('Button Pressed:');
    developer.log('Name: ${nameController.text}');
    developer.log('Clock In Time: ${clockInTime?.format(context)}');
    developer.log('Clock Out Time: ${clockOutTime?.format(context)}');
    developer.log('Late Mark After: ${lateMarkAfterController.text}');
    developer.log('Is Self Clocking: $isSelfClocking');

    // Fetch the logged-in user's ID asynchronously
    final authData = await AuthLocalDatasource().getAuthData();
    final String? updatedBy = authData.user?.id?.toString();

    // Validate input
    if (!mounted) {
      return;
    }

    if (nameController.text.isNotEmpty &&
        clockInTime != null &&
        clockOutTime != null &&
        lateMarkAfterController.text.isNotEmpty &&
        updatedBy != null) {
      String formattedClockInTime =
          '${clockInTime!.hour.toString().padLeft(2, '0')}:${clockInTime!.minute.toString().padLeft(2, '0')}:00';
      String formattedClockOutTime =
          '${clockOutTime!.hour.toString().padLeft(2, '0')}:${clockOutTime!.minute.toString().padLeft(2, '0')}:00';

      // Dispatch event to update shift
      context.read<UpdateShiftBloc>().add(
            UpdateShiftEvent.updateShift(
              id: widget.shift.id,
              name: nameController.text,
              clockInTime: formattedClockInTime,
              clockOutTime: formattedClockOutTime,
              lateMarkAfter: int.parse(lateMarkAfterController.text),
              isSelfClocking: isSelfClocking,
              updatedBy: updatedBy, // Pass the updatedBy value
            ),
          );

      Navigator.of(context).pop(); // Close the dialog
    } else {
      // Show error message if inputs are invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields'),
        ),
      );
    }
  }
}
