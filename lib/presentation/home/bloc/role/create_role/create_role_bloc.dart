import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/role_remote_datasource.dart';

part 'create_role_event.dart';
part 'create_role_state.dart';
part 'create_role_bloc.freezed.dart';

class CreateRoleBloc extends Bloc<CreateRoleEvent, CreateRoleState> {
  final RoleRemoteDatasource roleRemoteDatasource;
  CreateRoleBloc(
    this.roleRemoteDatasource,
  ) : super(const _Initial()) {
    on<_CreateRole>((event, emit) async {
      emit(const _Loading());
      final result = await roleRemoteDatasource.addRole(
        event.companyId,
        event.name,
        event.displayName,
        event.description,
      );
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Created()),
      );
    });
  }
}
