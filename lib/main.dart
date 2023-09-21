import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zilogic/common/common.dart';
import 'package:zilogic/core/providers.dart';
import 'package:zilogic/features/auth/controller/auth_controller.dart';
import 'package:zilogic/features/auth/view/signup_view.dart';
import 'package:zilogic/features/home/view/home_view.dart';
import 'package:zilogic/theme/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'zilogic',
      theme: isDarkMode ? AppTheme.theme : AppTheme.theme = AppThemeLight.theme,
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomeView();
              }
              return const SignUpView();
            },
            error: (error, st) => ErrorPage(
              error: error.toString(),
            ),
            loading: () => const LoadingPage(),
          ),
      debugShowCheckedModeBanner: false,
    );
  }
}
