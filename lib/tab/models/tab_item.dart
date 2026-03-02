part of 'models.dart';

enum TabItem {
  nutrition,
  plan,
  mood,
  profile;

  String get title {
    switch (this) {
      case TabItem.nutrition:
        return 'Nutrition';
      case TabItem.plan:
        return 'Plan';
      case TabItem.mood:
        return 'Mood';
      case TabItem.profile:
        return 'Profile';
    }
  }

  AppIcon get icon {
    switch (this) {
      case TabItem.nutrition:
        return AppIcon.nutrition;
      case TabItem.plan:
        return AppIcon.plan;
      case TabItem.mood:
        return AppIcon.mood;
      case TabItem.profile:
        return AppIcon.profile;
    }
  }

  int get $index => TabItem.values.indexOf(this);

  static const List<TabItem> items = [nutrition, plan, mood, profile];

  static TabItem? fromName(String? name) =>
      name == null || name.isEmpty
          ? null
          : items.cast<TabItem?>().firstWhere(
            (e) => e!.name == name,
            orElse: () => null,
          );
}
