import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../core/core.dart';
import '../../../data/models/response/shift_response_model.dart';
import '../bloc/shift/update_shift/update_shift_bloc.dart';
import '../bloc/shift/get_shift/get_shift_bloc.dart';

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
  late final TextEditingController shiftNameController;
  late final TextEditingController
      lateMarkAfterController; // New controller for lateMarkAfter
  TimeOfDay? clockInTime;
  TimeOfDay? clockOutTime;
  bool isSelfClocking = false;
  final logger = Logger();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with values not depending on context
    shiftNameController = TextEditingController(text: widget.initialName);
    lateMarkAfterController = TextEditingController(
      text: widget.shift.lateMarkAfter?.toString() ?? '',
    );

    // Set initial state values
    clockInTime = widget.initialClockInTime;
    clockOutTime = widget.initialClockOutTime;
    isSelfClocking = widget.initialIsSelfClocking;
    // Logging the initial values here because the context is fully initialized
    logger.i('Iniiih  Initial Clock In Time: $clockInTime');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Logging the initial values here because the context is fully initialized
    logger.i(
        'Ini dia Initial Clock In Time: ${widget.initialClockInTime.format(context)}');
    logger.i(
        'dan ini Initial Clock Out Time: ${widget.initialClockOutTime.format(context)}');
  }

  @override
  void dispose() {
    shiftNameController.dispose();
    lateMarkAfterController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isClockIn) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isClockIn ? clockInTime! : clockOutTime!,
    );
    if (picked != null) {
      setState(() {
        if (isClockIn) {
          clockInTime = picked;
        } else {
          clockOutTime = picked;
        }
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
                  'Edit Shift',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SpaceHeight(24.0),
                CustomTextField(
                  controller: shiftNameController,
                  label: 'Shift Name',
                  hintText: 'Please Enter Shift Name',
                  textInputAction: TextInputAction.next,
                ),
                const SpaceHeight(12.0),
                CustomTextField(
                  controller: lateMarkAfterController,
                  label: 'Late Mark After (minutes)',
                  hintText: 'Please Enter Late Mark After',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                ),
                const SpaceHeight(12.0),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _selectTime(context, true),
                      child: Text(
                        // Ensure the clockInTime is displayed correctly
                        clockInTime != null
                            ? clockInTime!.format(context)
                            : widget.initialClockInTime.format(context),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _selectTime(context, false),
                      child: Text(
                        // Ensure the clockOutTime is displayed correctly
                        clockOutTime != null
                            ? clockOutTime!.format(context)
                            : widget.initialClockOutTime.format(context),
                      ),
                    ),
                  ],
                ),
                const SpaceHeight(12.0),
                Row(
                  children: [
                    Checkbox(
                      value: isSelfClocking,
                      onChanged: (value) {
                        setState(() {
                          isSelfClocking = value!;
                        });
                      },
                    ),
                    const Text('Self Clocking'),
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
                      child: BlocConsumer<UpdateShiftBloc, UpdateShiftState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            updated: () {
                              context.read<GetShiftBloc>().add(
                                    const GetShiftEvent.getShift(),
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
                                if (clockInTime != null &&
                                    clockOutTime != null &&
                                    lateMarkAfterController.text.isNotEmpty) {
                                  logger.i(
                                    'Editing shift with: name=${shiftNameController.text}, clockInTime=${clockInTime!.format(context)}, clockOutTime=${clockOutTime!.format(context)}, isSelfClocking=$isSelfClocking, lateMarkAfter=${lateMarkAfterController.text}, companyId=${widget.companyId}, createdBy=${widget.createdBy}',
                                  );

                                  context.read<UpdateShiftBloc>().add(
                                        UpdateShiftEvent.updateShift(
                                          id: widget.shiftId,
                                          name: shiftNameController.text,
                                          clockInTime:
                                              '${clockInTime!.hour}:${clockInTime!.minute}',
                                          clockOutTime:
                                              '${clockOutTime!.hour}:${clockOutTime!.minute}',
                                          isSelfClocking: isSelfClocking,
                                          lateMarkAfter: int.parse(
                                              lateMarkAfterController.text),
                                        ),
                                      );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please complete all fields.',
                                      ),
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
