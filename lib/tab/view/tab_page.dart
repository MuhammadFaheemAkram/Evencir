part of 'view.dart';

class TabPage extends StatelessWidget {
  const TabPage({super.key, this.initialTab = TabItem.nutrition});

  final TabItem initialTab;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TabCubit(initialTab: initialTab),
      child: const TabView(),
    );
  }
}

extension ChangeTabContext on BuildContext {
  void changeTab(TabItem tab) {
    read<TabCubit>().onTabChanged(tab);
  }

  TabItem get currentTab => read<TabCubit>().state.currentTab;
}
