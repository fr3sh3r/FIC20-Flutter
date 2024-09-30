part of 'update_leave_types_bloc.dart';

@freezed
class UpdateLeaveTypesState with _$UpdateLeaveTypesState {
  const factory UpdateLeaveTypesState.initial() = _Initial;
  const factory UpdateLeaveTypesState.loading() = _Loading;
  const factory UpdateLeaveTypesState.error(String message) = _Error;
  const factory UpdateLeaveTypesState.success() = _Success;
}
