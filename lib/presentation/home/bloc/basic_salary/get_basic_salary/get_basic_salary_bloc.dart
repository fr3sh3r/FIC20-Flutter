import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/basic_salary_remote_datasource.dart';
import '../../../../../data/models/response/basic_salary_response_model.dart';

part 'get_basic_salary_event.dart';
part 'get_basic_salary_state.dart';
part 'get_basic_salary_bloc.freezed.dart';

class GetBasicSalaryBloc
    extends Bloc<GetBasicSalaryEvent, GetBasicSalaryState> {
  final BasicSalaryRemoteDatasource basicSalaryRemoteDatasource;
  GetBasicSalaryBloc(
    this.basicSalaryRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetBasicSalary>((event, emit) async {
      emit(const _Loading());
      final result = await basicSalaryRemoteDatasource.getBasicSalaries();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
