import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import '../../../core/core.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../bloc/shift/create_shift/create_shift_bloc.dart';

class AddNewShift extends StatefulWidget {
  const AddNewShift({super.key});

  @override
  State<AddNewShift> createState() => _AddNewShiftState();
}

class _AddNewShiftState extends State<AddNewShift> {
  late final TextEditingController nameController;
  late final TextEditingController lateMarkAfterController;
  TimeOfDay? clockInTime;
  TimeOfDay? clockOutTime;
  late bool isSelfClocking;

  @override
  void initState() {
    nameController = TextEditingController();
    lateMarkAfterController = TextEditingController();
    isSelfClocking = false;
    super.initState();
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
                  'Add New Shift',
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
                        _onCreatePressed(context); // Extracted function
                      },
                      label: 'Create',
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

  Future<void> _onCreatePressed(BuildContext context) async {
    // Log the input values before validation
    developer.log('Button Pressed:');
    developer.log('Name: ${nameController.text}');
    developer.log('Clock In Time: ${clockInTime?.format(context)}');
    developer.log('Clock Out Time: ${clockOutTime?.format(context)}');
    developer.log('Late Mark After: ${lateMarkAfterController.text}');
    developer.log('Is Self Clocking: $isSelfClocking');

    // Fetch the logged-in user's ID asynchronously
    final authData = await AuthLocalDatasource().getAuthData();
    final String? createdBy = authData.user?.id
        ?.toString(); // Ensure the createdBy is properly retrieved

    // Validate input
    if (!mounted) {
      return; // Check if the widget is still mounted before continuing
    }

    if (nameController.text.isNotEmpty &&
        clockInTime != null &&
        clockOutTime != null &&
        lateMarkAfterController.text.isNotEmpty &&
        createdBy != null) {
      // Convert TimeOfDay to string in HH:MM:SS format
      String formattedClockInTime =
          '${clockInTime!.hour.toString().padLeft(2, '0')}:${clockInTime!.minute.toString().padLeft(2, '0')}:00';
      String formattedClockOutTime =
          '${clockOutTime!.hour.toString().padLeft(2, '0')}:${clockOutTime!.minute.toString().padLeft(2, '0')}:00';

      // Dispatch event to add a new shift, ensuring createdBy is included
      if (mounted) {
        context.read<CreateShiftBloc>().add(
              CreateShiftEvent.createShift(
                name: nameController.text,
                clockInTime: formattedClockInTime,
                clockOutTime: formattedClockOutTime,
                lateMarkAfter: int.parse(lateMarkAfterController.text),
                isSelfClocking: isSelfClocking,
                createdBy: createdBy, // Pass the createdBy value here
              ),
            );

        // Close the dialog
        Navigator.of(context).pop();
      }
    } else {
      // Show error message if inputs are invalid
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please complete all fields'),
          ),
        );
      }
    }
  }
}
