import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/designation_remote_datasource.dart';

part 'update_designation_bloc.freezed.dart';
part 'update_designation_event.dart';
part 'update_designation_state.dart';

class UpdateDesignationBloc
    extends Bloc<UpdateDesignationEvent, UpdateDesignationState> {
  final DesignationRemoteDatasource designationRemoteDatasource;
  UpdateDesignationBloc(
    this.designationRemoteDatasource,
  ) : super(const _Initial()) {
    on<_UpdateDesignation>((event, emit) async {
      emit(const _Loading());
      final result = await designationRemoteDatasource.editDesignation(
          event.id, event.name, event.description);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Updated()),
      );
    });
  }
}
