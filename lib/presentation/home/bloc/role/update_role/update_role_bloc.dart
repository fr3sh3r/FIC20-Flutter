import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/role_remote_datasource.dart';

part 'update_role_event.dart';
part 'update_role_state.dart';
part 'update_role_bloc.freezed.dart';

class UpdateRoleBloc extends Bloc<UpdateRoleEvent, UpdateRoleState> {
  final RoleRemoteDatasource roleRemoteDatasource;
  UpdateRoleBloc(
    this.roleRemoteDatasource,
  ) : super(const _Initial()) {
    on<_UpdateRole>((event, emit) async {
      emit(const _Loading());
      final result = await roleRemoteDatasource.editRole(
        event.id,
        event.companyId,
        event.name,
        event.displayName,
        event.description,
      );
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Success()),
      );
    });
  }
}
