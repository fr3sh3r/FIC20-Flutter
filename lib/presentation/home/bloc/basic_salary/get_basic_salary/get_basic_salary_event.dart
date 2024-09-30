part of 'get_basic_salary_bloc.dart';

@freezed
class GetBasicSalaryEvent with _$GetBasicSalaryEvent {
  const factory GetBasicSalaryEvent.started() = _Started;
  const factory GetBasicSalaryEvent.getBasicSalary() = _GetBasicSalary;
}
