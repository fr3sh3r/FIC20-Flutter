part of 'update_leave_types_bloc.dart';

@freezed
class UpdateLeaveTypesEvent with _$UpdateLeaveTypesEvent {
  const factory UpdateLeaveTypesEvent.started() = _Started;
  const factory UpdateLeaveTypesEvent.updateLeaveTypes(
    int id,
    String name,
    bool isPaid,
    int totalLeave,
    int maxLeavePerMonth,
    int createdBy,
  ) = _UpdateLeaveTypes;
}
