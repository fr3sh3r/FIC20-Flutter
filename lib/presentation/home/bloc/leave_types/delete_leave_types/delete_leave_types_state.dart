part of 'delete_leave_types_bloc.dart';

@freezed
class DeleteLeaveTypesState with _$DeleteLeaveTypesState {
  const factory DeleteLeaveTypesState.initial() = _Initial;
  const factory DeleteLeaveTypesState.loading() = _Loading;
  const factory DeleteLeaveTypesState.deleted() = _Deleted;
  const factory DeleteLeaveTypesState.error(String message) = _Error;
}
