import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:evencir_project/tab/models/models.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit({TabItem initialTab = TabItem.nutrition})
    : super(TabState(currentTab: initialTab));

  void onTabChanged(TabItem tab) {
    if (tab == state.currentTab) return;
    emit(TabState(currentTab: tab));
  }
}
