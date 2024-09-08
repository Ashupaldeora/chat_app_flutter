part of 'visibility_cubit.dart';

abstract class VisibilityState extends Equatable {
  const VisibilityState();

  @override
  List<Object> get props => [];
}

class VisibilityVisible extends VisibilityState {}

class VisibilityHidden extends VisibilityState {}
