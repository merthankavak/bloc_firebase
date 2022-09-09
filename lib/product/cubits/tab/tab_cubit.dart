import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(TabState.initial());

  void changeTabIndex(int index) {
    emit(state.copyWith(tabIndex: index));
  }
}
