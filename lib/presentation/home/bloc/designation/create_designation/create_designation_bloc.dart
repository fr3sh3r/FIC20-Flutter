import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/designation_remote_datasource.dart';

part 'create_designation_bloc.freezed.dart';
part 'create_designation_event.dart';
part 'create_designation_state.dart';

class CreateDesignationBloc
    extends Bloc<CreateDesignationEvent, CreateDesignationState> {
  final DesignationRemoteDatasource designationRemoteDatasource;
  CreateDesignationBloc(
    this.designationRemoteDatasource,
  ) : super(const _Initial()) {
    on<_CreateDesignation>((event, emit) async {
      emit(const _Loading());
      final result = await designationRemoteDatasource.addDesignation(
          event.name, event.description);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Created()),
      );
    });
  }
}
