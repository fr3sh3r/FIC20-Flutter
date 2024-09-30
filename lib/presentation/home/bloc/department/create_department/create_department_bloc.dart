import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/department_remote_datasource.dart';

part 'create_department_event.dart';
part 'create_department_state.dart';
part 'create_department_bloc.freezed.dart';

class CreateDepartmentBloc
    extends Bloc<CreateDepartmentEvent, CreateDepartmentState> {
  final DepartmentRemoteDatasource departmentRemoteDatasource;
  CreateDepartmentBloc(
    this.departmentRemoteDatasource,
  ) : super(const _Initial()) {
    on<_CreateDepartment>((event, emit) async {
      emit(const _Loading());
      final result = await departmentRemoteDatasource.createDepartment(
          event.name, event.description);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Created()),
      );
    });
  }
}
