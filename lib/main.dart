import 'package:evencir_project/router/app_router.dart';
import 'package:evencir_project/theme/app_theme.dart';
import 'package:evencir_project/utils/date_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DateNotifier(initialDate: DateTime(2024, 12, 22)),
      child: MaterialApp.router(
        title: 'Evencir',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        //themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
