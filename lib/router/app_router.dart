import 'package:evencir_project/tab/view/view.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (context, state) => const TabPage())],
);
