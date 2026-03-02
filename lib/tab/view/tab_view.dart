part of 'view.dart';

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabCubit, TabState>(
      buildWhen:
          (previous, current) => previous.currentTab != current.currentTab,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _TabBody(currentTab: state.currentTab),
          bottomNavigationBar: _BottomNavBar(currentTab: state.currentTab),
        );
      },
    );
  }
}

class _TabBody extends StatelessWidget {
  const _TabBody({required this.currentTab});

  final TabItem currentTab;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateCubit, DateState>(
      builder: (context, dateState) {
        switch (currentTab) {
          case TabItem.nutrition:
            return HomePage(selectedDate: dateState.selectedDate);
          case TabItem.plan:
            return PlanPage(selectedDate: dateState.selectedDate);
          case TabItem.mood:
            return const MoodView();
          case TabItem.profile:
            return const ProfilePage();
        }
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentTab});

  final TabItem currentTab;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: colors.cardBorder, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                TabItem.items
                    .map(
                      (tab) =>
                          _TabItemView(tab: tab, selected: tab == currentTab),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}

class _TabItemView extends StatelessWidget {
  const _TabItemView({required this.tab, this.selected = false});

  final TabItem tab;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: () => context.read<TabCubit>().onTabChanged(tab),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcons.svg(
              tab.icon,
              color: selected ? colors.navActive : colors.navInactive,
            ),
            const SizedBox(height: 4),
            Text(
              tab.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: selected ? colors.navActive : colors.navInactive,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
