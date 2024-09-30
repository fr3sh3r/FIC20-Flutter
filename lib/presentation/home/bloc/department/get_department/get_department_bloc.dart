import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_hrm_inventory_pos_app/data/datasources/department_remote_datasource.dart';

import '../../../../../data/models/response/department_response_model.dart';

part 'get_department_bloc.freezed.dart';
part 'get_department_event.dart';
part 'get_department_state.dart';

class GetDepartmentBloc extends Bloc<GetDepartmentEvent, GetDepartmentState> {
  final DepartmentRemoteDatasource departmentRemoteDatasource;
  GetDepartmentBloc(
    this.departmentRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetDepartments>((event, emit) async {
      emit(const _Loading());
      final result = await departmentRemoteDatasource.getDepartments();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
