part of 'get_designation_bloc.dart';

@freezed
class GetDesignationState with _$GetDesignationState {
  const factory GetDesignationState.initial() = _Initial;
  const factory GetDesignationState.loading() = _Loading;
  const factory GetDesignationState.loaded(List<Designation> data) =
      _Loaded;
  const factory GetDesignationState.error(String message) = _Error;
}
