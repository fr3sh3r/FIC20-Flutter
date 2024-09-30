part of 'delete_designation_bloc.dart';

@freezed
class DeleteDesignationState with _$DeleteDesignationState {
  const factory DeleteDesignationState.initial() = _Initial;
  const factory DeleteDesignationState.loading() = _Loading;
  const factory DeleteDesignationState.deleted() = _Deleted;
  const factory DeleteDesignationState.error(String message) = _Error;
}
