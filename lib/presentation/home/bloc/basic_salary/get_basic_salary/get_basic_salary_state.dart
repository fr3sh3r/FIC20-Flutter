part of 'get_basic_salary_bloc.dart';

@freezed
class GetBasicSalaryState with _$GetBasicSalaryState {
  const factory GetBasicSalaryState.initial() = _Initial;
  const factory GetBasicSalaryState.loading() = _Loading;
  const factory GetBasicSalaryState.loaded(List<BasicSalary> data) = _Loaded;
  const factory GetBasicSalaryState.error(String message) = _Error;
}
