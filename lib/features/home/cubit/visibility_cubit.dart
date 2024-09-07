import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'visibility_state.dart';

class VisibilityCubit extends Cubit<VisibilityState> {
  VisibilityCubit() : super(VisibilityVisible());

  void hideTitle() => emit(VisibilityHidden());

  void showTitle() => emit(VisibilityVisible());
}
