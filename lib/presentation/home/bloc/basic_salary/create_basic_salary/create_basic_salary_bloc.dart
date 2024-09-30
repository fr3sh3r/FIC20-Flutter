import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/basic_salary_remote_datasource.dart';

part 'create_basic_salary_event.dart';
part 'create_basic_salary_state.dart';
part 'create_basic_salary_bloc.freezed.dart';

class CreateBasicSalaryBloc
    extends Bloc<CreateBasicSalaryEvent, CreateBasicSalaryState> {
  final BasicSalaryRemoteDatasource basicSalaryRemoteDatasource;
  CreateBasicSalaryBloc(
    this.basicSalaryRemoteDatasource,
  ) : super(const _Initial()) {
    on<_CreateBasicSalary>((event, emit) async {
      emit(const _Loading());
      final result = await basicSalaryRemoteDatasource.addBasicSalary(
          event.userId, event.basicSalary);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Created()),
      );
    });
  }
}
