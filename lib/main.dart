import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/store.dart';
import 'screens/shell.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';
import 'theme/motion.dart';
import 'widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('it_IT');
  final store = AppStore();
  await store.load();
  runApp(IdroRipartoApp(store: store));
}

class IdroRipartoApp extends StatelessWidget {
  const IdroRipartoApp({super.key, required this.store});
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return StoreScope(
      store: store,
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              final light = AppTheme.from(
                AppTheme.materialYou(lightDynamic, Brightness.light),
              );
              final dark = AppTheme.from(
                AppTheme.materialYou(darkDynamic, Brightness.dark),
              );
              return MaterialApp(
                title: 'IdroRiparto',
                debugShowCheckedModeBanner: false,
                theme: light,
                darkTheme: dark,
                themeMode: store.themeMode,
                locale: const Locale('it', 'IT'),
                supportedLocales: const [Locale('it', 'IT'), Locale('en')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: AnimatedSwitcher(
                  duration: AppMotion.dEffects,
                  switchInCurve: AppMotion.effects,
                  switchOutCurve: AppMotion.effects,
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: !store.ready
                      ? const _Boot(key: ValueKey('boot'))
                      : store.condominio == null
                      ? const WelcomeScreen(key: ValueKey('welcome'))
                      : const AppShell(key: ValueKey('shell')),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _Boot extends StatelessWidget {
  const _Boot({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Appear(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LogoMark(size: 88),
              const SizedBox(height: 18),
              Text(
                'IdroRiparto',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
