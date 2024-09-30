part of 'create_designation_bloc.dart';

@freezed
class CreateDesignationState with _$CreateDesignationState {
  const factory CreateDesignationState.initial() = _Initial;
  const factory CreateDesignationState.loading() = _Loading;
  const factory CreateDesignationState.created() = _Created;
  const factory CreateDesignationState.error(String message) = _Error;
}

