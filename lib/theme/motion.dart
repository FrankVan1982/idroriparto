import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Material 3 Expressive: molle spaziali (posizione) ed effects (colore/opacità).
class AppMotion {
  static const spatial = Cubic(0.32, 0.72, 0, 1);
  static const spatialEmphasized = Cubic(0.22, 1.18, 0.36, 1);
  static const effects = Cubic(0.4, 0.0, 0.2, 1);

  static const dFast = Duration(milliseconds: 180);
  static const dEffects = Duration(milliseconds: 280);
  static const dSpatial = Duration(milliseconds: 480);
  static const dSlow = Duration(milliseconds: 640);

  static bool reduce(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration of(BuildContext context, Duration raw) =>
      reduce(context) ? Duration.zero : raw;

  static void tap() {
    HapticFeedback.selectionClick();
  }

  static void impact() {
    HapticFeedback.lightImpact();
  }
}

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required WidgetBuilder builder, super.settings})
    : super(
        pageBuilder: (context, animation, secondary) => builder(context),
        transitionDuration: AppMotion.dSpatial,
        reverseTransitionDuration: AppMotion.dEffects,
        transitionsBuilder: (context, animation, secondary, child) {
          if (AppMotion.reduce(context)) return child;
          final enter = CurvedAnimation(
            parent: animation,
            curve: AppMotion.spatialEmphasized,
            reverseCurve: AppMotion.effects,
          );
          return FadeTransition(
            opacity: enter,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.035, 0.02),
                end: Offset.zero,
              ).animate(enter),
              child: child,
            ),
          );
        },
      );
}

Future<T?> pushApp<T>(BuildContext context, Widget page) {
  AppMotion.tap();
  return Navigator.of(context).push<T>(AppPageRoute(builder: (_) => page));
}

class Appear extends StatelessWidget {
  const Appear({
    super.key,
    required this.child,
    this.index = 0,
    this.slide = 18,
  });

  final Widget child;
  final int index;
  final double slide;

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduce(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + index * 55),
      curve: AppMotion.spatialEmphasized,
      builder: (context, t, child) {
        return Opacity(
          opacity: t.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * slide),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
