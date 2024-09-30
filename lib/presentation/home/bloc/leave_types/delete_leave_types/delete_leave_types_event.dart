part of 'delete_leave_types_bloc.dart';

@freezed
class DeleteLeaveTypesEvent with _$DeleteLeaveTypesEvent {
  const factory DeleteLeaveTypesEvent.started() = _Started;
  const factory DeleteLeaveTypesEvent.deleteLeaveTypes({required int id}) =
      _DeleteLeaveTypes;
}