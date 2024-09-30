import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/basic_salary_remote_datasource.dart';

part 'update_basic_salary_event.dart';
part 'update_basic_salary_state.dart';
part 'update_basic_salary_bloc.freezed.dart';

class UpdateBasicSalaryBloc
    extends Bloc<UpdateBasicSalaryEvent, UpdateBasicSalaryState> {
  final BasicSalaryRemoteDatasource basicSalaryRemoteDatasource;
  UpdateBasicSalaryBloc(
    this.basicSalaryRemoteDatasource,
  ) : super(const _Initial()) {
    on<_UpdateBasicSalary>((event, emit) async {
      emit(const _Loading());

      // Log to check the received values
      developer.log(
        'LOG updateSalaryBLoC: Received userId: ${event.userId}, basicSalary: ${event.basicSalary}',
        name: 'UpdateBasicSalaryBloc',
      );
      final result = await basicSalaryRemoteDatasource.editBasicSalary(
          event.id, event.userId, event.basicSalary);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Updated()),
      );
    });
  }
}
