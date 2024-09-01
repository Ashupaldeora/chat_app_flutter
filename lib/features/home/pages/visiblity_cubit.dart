import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VisibilityState extends Equatable {
  const VisibilityState();

  @override
  List<Object> get props => [];
}

class VisibilityVisible extends VisibilityState {}

class VisibilityHidden extends VisibilityState {}

class VisibilityCubit extends Cubit<VisibilityState> {
  VisibilityCubit() : super(VisibilityVisible());

  void hideTitle() => emit(VisibilityHidden());

  void showTitle() => emit(VisibilityVisible());
}
