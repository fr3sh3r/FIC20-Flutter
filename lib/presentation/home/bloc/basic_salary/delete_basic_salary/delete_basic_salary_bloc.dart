import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../data/datasources/basic_salary_remote_datasource.dart';

part 'delete_basic_salary_event.dart';
part 'delete_basic_salary_state.dart';
part 'delete_basic_salary_bloc.freezed.dart';

class DeleteBasicSalaryBloc
    extends Bloc<DeleteBasicSalaryEvent, DeleteBasicSalaryState> {
  final BasicSalaryRemoteDatasource basicSalaryRemoteDatasource;
  DeleteBasicSalaryBloc(
    this.basicSalaryRemoteDatasource,
  ) : super(const _Initial()) {
    on<_DeleteBasicSalary>((event, emit) async {
      emit(const _Loading());
      final result =
          await basicSalaryRemoteDatasource.deleteBasicSalary(event.id);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Deleted()),
      );
    });
  }
}
