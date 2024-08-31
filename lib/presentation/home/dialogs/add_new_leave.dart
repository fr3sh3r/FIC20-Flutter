import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../models/leaves_model.dart';

class AddNewLeave extends StatefulWidget {
  const AddNewLeave({super.key});

  @override
  State<AddNewLeave> createState() => _AddNewLeaveState();
}

class _AddNewLeaveState extends State<AddNewLeave> {
  final users = ['Fauzan', 'Abdillah'];
  final leaveTypes = ['Annual Leave', 'Sick Leave', 'Maternity Leave'];
  final statuses = ['Pending', 'Approve', 'Rejected'];

  late final TextEditingController usernameController;
  late final TextEditingController leaveTypeController;
  late final TextEditingController reasonController;
  LeaveStatus? statusSelected;
  DateTime? startDate;
  DateTime? endDate;
  late bool isHalfDay;

  @override
  void initState() {
    usernameController = TextEditingController(text: users.first);
    leaveTypeController = TextEditingController(text: leaveTypes.first);
    reasonController = TextEditingController();
    isHalfDay = false;
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    leaveTypeController.dispose();
    reasonController.dispose();
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
                  'Add New Leave',
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
                  child: CustomDropdown(
                    value: usernameController.text,
                    items: users,
                    label: 'User Name',
                    onChanged: (value) {
                      usernameController.text = value ?? '';
                      setState(() {});
                    },
                  ),
                ),
                const SpaceWidth(16.0),
                Flexible(
                  child: CustomDropdown(
                    value: leaveTypeController.text,
                    items: leaveTypes,
                    label: 'Leave Type',
                    onChanged: (value) {
                      leaveTypeController.text = value ?? '';
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            const SpaceHeight(16.0),
            Row(
              children: [
                Flexible(
                  child: CustomDatePicker(
                    initialDate: startDate,
                    label: 'Start Date',
                    onDateSelected: (selectedDate) {
                      startDate = selectedDate;
                    },
                  ),
                ),
                const SpaceWidth(16.0),
                Flexible(
                  child: CustomDatePicker(
                    initialDate: endDate,
                    label: 'End Date',
                    onDateSelected: (selectedDate) {
                      endDate = selectedDate;
                    },
                  ),
                ),
              ],
            ),
            const SpaceHeight(16.0),
            YesNoToggle(
              label: 'Is Half Day',
              initialValue: isHalfDay,
              onChanged: (isYesSelected) {
                isHalfDay = isYesSelected;
              },
            ),
            const SpaceHeight(16.0),
            CustomTextField(
              controller: reasonController,
              label: 'Reason',
              hintText: 'Please Enter Reason',
              maxLines: 5,
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
                      onPressed: () => context.pop(),
                      label: 'Cancel',
                    ),
                  ),
                  const SpaceWidth(16.0),
                  Flexible(
                    child: Button.filled(
                      onPressed: () {},
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
}
