import 'package:evencir_project/screens/home_screen.dart';
import 'package:evencir_project/screens/mood_screen.dart';
import 'package:evencir_project/screens/plan_screen.dart';
import 'package:evencir_project/screens/profile_screen.dart';
import 'package:evencir_project/theme/app_colors_extension.dart';
import 'package:evencir_project/utils/app_icons.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime(2024, 12, 22);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            selectedDate: _selectedDate,
            onDateChanged: (date) => setState(() => _selectedDate = date),
          ),
          PlanScreen(selectedDate: _selectedDate),
          const MoodScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
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
            children: [
              _buildNavItem(
                icon: AppIcon.nutrition,
                label: 'Nutrition',
                index: 0,
              ),
              _buildNavItem(icon: AppIcon.plan, label: 'Plan', index: 1),
              _buildNavItem(icon: AppIcon.mood, label: 'Mood', index: 2),
              _buildNavItem(icon: AppIcon.profile, label: 'Profile', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required AppIcon icon,
    required String label,
    required int index,
  }) {
    final bool isActive = _currentIndex == index;
    final colors = context.appColors;

    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcons.svg(
              icon,
              color: isActive ? colors.navActive : colors.navInactive,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isActive ? colors.navActive : colors.navInactive,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
