part of 'create_basic_salary_bloc.dart';

@freezed
class CreateBasicSalaryState with _$CreateBasicSalaryState {
  const factory CreateBasicSalaryState.initial() = _Initial;
  const factory CreateBasicSalaryState.loading() = _Loading;
  const factory CreateBasicSalaryState.created() = _Created;
  const factory CreateBasicSalaryState.error(String message) = _Error;
}
