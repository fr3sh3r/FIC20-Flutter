part of 'get_department_bloc.dart';

@freezed
class GetDepartmentEvent with _$GetDepartmentEvent {
  const factory GetDepartmentEvent.started() = _Started;
  const factory GetDepartmentEvent.getDepartments() = _GetDepartments;
  
}
