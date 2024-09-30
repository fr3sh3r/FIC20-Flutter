part of 'create_leave_types_bloc.dart';

@freezed
class CreateLeaveTypesState with _$CreateLeaveTypesState {
  const factory CreateLeaveTypesState.initial() = _Initial;
  const factory CreateLeaveTypesState.loading() = _Loading;
  const factory CreateLeaveTypesState.created() = _Created;
  const factory CreateLeaveTypesState.error(String message) = _Error;
}
