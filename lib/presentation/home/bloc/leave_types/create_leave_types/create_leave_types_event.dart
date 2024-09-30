part of 'create_leave_types_bloc.dart';

@freezed
class CreateLeaveTypesEvent with _$CreateLeaveTypesEvent {
  const factory CreateLeaveTypesEvent.started() = _Started;
  const factory CreateLeaveTypesEvent.createLeaveTypes(
    String name,
    bool isPaid,
    int totalLeaves,
    int maxLeavePerMonth,
  ) = _CreateLeaveTypes;
}


// String name, bool isPaid, int totalLeaves, int maxLeave, int createdBy