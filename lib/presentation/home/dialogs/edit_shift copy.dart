import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../core/components/custom_time_picker.dart';
import '../../../data/models/response/shift_response_model.dart';
import '../bloc/shift/update_shift/update_shift_bloc.dart';

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
  late TimeOfDay clockInTime;
  late TimeOfDay clockOutTime;
  bool isSelfClocking = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    lateMarkAfterController =
        TextEditingController(text: widget.shift.lateMarkAfter.toString());

    // Set initial clock-in and clock-out times
    clockInTime = widget.initialClockInTime;
    clockOutTime = widget.initialClockOutTime;
    isSelfClocking = widget.initialIsSelfClocking;
  }

  @override
  void dispose() {
    nameController.dispose();
    lateMarkAfterController.dispose();
    super.dispose();
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 600.0,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Edit Shift'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Please Enter Name',
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  child: CustomTimePicker(
                    initialTime: clockInTime,
                    label: 'Clock In Time',
                    onTimeSelected: (TimeOfDay time) {
                      setState(() {
                        clockInTime = time;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Flexible(
                  child: CustomTimePicker(
                    initialTime: clockOutTime,
                    label: 'Clock Out Time',
                    onTimeSelected: (TimeOfDay time) {
                      setState(() {
                        clockOutTime = time;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  child: TextField(
                    controller: lateMarkAfterController,
                    decoration: const InputDecoration(
                      labelText: 'Late Mark After',
                      hintText: 'Please Enter Late Mark After',
                      suffixText: 'Minutes',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            SwitchListTile(
              title: const Text('Self Clocking'),
              value: isSelfClocking,
              onChanged: (value) {
                setState(() {
                  isSelfClocking = value;
                });
              },
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _onSavePressed(context);
                  },
                  child: const Text('Save'),
                ),
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
    developer.log('Clock In Time: ${formatTimeOfDay(clockInTime)}');
    developer.log('Clock Out Time: ${formatTimeOfDay(clockOutTime)}');
    developer.log('Late Mark After: ${lateMarkAfterController.text}');
    developer.log('Is Self Clocking: $isSelfClocking');

    try {
      if (nameController.text.isNotEmpty &&
          lateMarkAfterController.text.isNotEmpty) {
        final parsedClockInTime = formatTimeOfDay(clockInTime) + ':00';
        final parsedClockOutTime = formatTimeOfDay(clockOutTime) + ':00';

        developer.log('Formatted Clock In Time for DB: $parsedClockInTime');
        developer.log('Formatted Clock Out Time for DB: $parsedClockOutTime');

        context.read<UpdateShiftBloc>().add(
              UpdateShiftEvent.updateShift(
                id: widget.shiftId,
                name: nameController.text,
                clockInTime: parsedClockInTime,
                clockOutTime: parsedClockOutTime,
                lateMarkAfter: int.parse(lateMarkAfterController.text),
                isSelfClocking: isSelfClocking,
              ),
            );

        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all fields')),
        );
      }
    } catch (e) {
      developer.log('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid input. Please check your entries.')),
      );
    }
  }
}
