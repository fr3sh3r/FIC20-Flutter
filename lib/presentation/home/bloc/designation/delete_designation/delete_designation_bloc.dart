import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/designation_remote_datasource.dart';

part 'delete_designation_bloc.freezed.dart';
part 'delete_designation_event.dart';
part 'delete_designation_state.dart';

class DeleteDesignationBloc
    extends Bloc<DeleteDesignationEvent, DeleteDesignationState> {
  final DesignationRemoteDatasource designationRemoteDatasource;
  DeleteDesignationBloc(
    this.designationRemoteDatasource,
  ) : super(const _Initial()) {
    on<_DeleteDesignation>((event, emit) async {
      emit(const _Loading());
      final result =
          await designationRemoteDatasource.deleteDesignation(event.id);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Deleted()),
      );
    });
  }
}
