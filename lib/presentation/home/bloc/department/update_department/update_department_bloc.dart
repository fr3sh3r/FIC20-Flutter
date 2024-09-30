import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/department_remote_datasource.dart';

part 'update_department_bloc.freezed.dart';
part 'update_department_event.dart';
part 'update_department_state.dart';

class UpdateDepartmentBloc
    extends Bloc<UpdateDepartmentEvent, UpdateDepartmentState> {
  final DepartmentRemoteDatasource departmentRemoteDatasource;
  UpdateDepartmentBloc(
    this.departmentRemoteDatasource,
  ) : super(const _Initial()) {
    on<_UpdateDepartment>((event, emit) async {
      emit(const _Loading());
      final result = await departmentRemoteDatasource.updateDepartment(
          event.id, event.name, event.description);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Updated()),
      );
    });
  }
}
