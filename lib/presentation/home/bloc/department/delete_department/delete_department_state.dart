part of 'delete_department_bloc.dart';

@freezed
class DeleteDepartmentState with _$DeleteDepartmentState {
  const factory DeleteDepartmentState.initial() = _Initial;
  const factory DeleteDepartmentState.loading() = _Loading;
  const factory DeleteDepartmentState.deleted() = _Deleted;
  const factory DeleteDepartmentState.error(String message) = _Error;
}
