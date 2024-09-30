import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/designation_remote_datasource.dart';
import '../../../../../data/models/response/designation_response_model.dart';

part 'get_designation_bloc.freezed.dart';
part 'get_designation_event.dart';
part 'get_designation_state.dart';

class GetDesignationBloc
    extends Bloc<GetDesignationEvent, GetDesignationState> {
  final DesignationRemoteDatasource designationRemoteDatasource;
  GetDesignationBloc(
    this.designationRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetDesignations>((event, emit) async {
      emit(const _Loading());
      final result = await designationRemoteDatasource.getDesignations();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data ?? [])),
      );
    });
  }
}
