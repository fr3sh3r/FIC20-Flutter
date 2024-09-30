part of 'get_department_bloc.dart';

@freezed
class GetDepartmentState with _$GetDepartmentState {
  const factory GetDepartmentState.initial() = _Initial;
  const factory GetDepartmentState.loading() = _Loading;
  const factory GetDepartmentState.loaded(List<Department> data) = _Loaded;
  const factory GetDepartmentState.error(String message) = _Error;
}
