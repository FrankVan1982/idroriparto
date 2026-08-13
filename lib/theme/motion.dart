import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Molle Material 3 Expressive (massa = 1).
/// Spatial = posizione/scala. Effects = opacità/colore (critica, niente rimbalzo).
class M3SpringCurve extends Curve {
  const M3SpringCurve({
    required this.stiffness,
    required this.dampingRatio,
  });

  static const spatial = M3SpringCurve(stiffness: 380, dampingRatio: 0.9);
  static const spatialEmphasized = M3SpringCurve(
    stiffness: 260,
    dampingRatio: 0.86,
  );
  static const effects = M3SpringCurve(stiffness: 1600, dampingRatio: 1.0);

  final double stiffness;
  final double dampingRatio;

  @override
  double transformInternal(double t) {
    if (t <= 0) return 0;
    if (t >= 1) return 1;
    final omega0 = math.sqrt(stiffness);
    final zeta = dampingRatio;
    final settle = 4.4 / (zeta * omega0);
    final time = t * settle;
    if (zeta >= 1) {
      return 1 - (1 + omega0 * time) * math.exp(-omega0 * time);
    }
    final wd = omega0 * math.sqrt(1 - zeta * zeta);
    final env = math.exp(-zeta * omega0 * time);
    return 1 -
        env * (math.cos(wd * time) + (zeta * omega0 / wd) * math.sin(wd * time));
  }
}

class AppMotion {
  static const spatial = M3SpringCurve.spatial;
  static const spatialEmphasized = M3SpringCurve.spatialEmphasized;
  static const effects = M3SpringCurve.effects;

  static const dFast = Duration(milliseconds: 160);
  static const dEffects = Duration(milliseconds: 200);
  static const dSpatial = Duration(milliseconds: 400);
  static const dSlow = Duration(milliseconds: 520);

  static bool reduce(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration of(BuildContext context, Duration raw) =>
      reduce(context) ? Duration.zero : raw;

  static void tap() => HapticFeedback.selectionClick();
  static void impact() => HapticFeedback.lightImpact();
}

/// Transizione fade-through M3: niente slide elastico.
class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required WidgetBuilder builder, super.settings})
    : super(
        pageBuilder: (context, animation, secondary) => builder(context),
        transitionDuration: AppMotion.dEffects,
        reverseTransitionDuration: AppMotion.dFast,
        transitionsBuilder: (context, animation, secondary, child) {
          if (AppMotion.reduce(context)) return child;
          final inFade = CurvedAnimation(
            parent: animation,
            curve: AppMotion.effects,
          );
          return FadeTransition(
            opacity: inFade,
            child: child,
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
    this.slide = 0,
  });

  final Widget child;
  final int index;
  final double slide;

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduce(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 200 + index * 24),
      curve: AppMotion.effects,
      builder: (context, t, child) {
        Widget out = Opacity(opacity: t.clamp(0.0, 1.0), child: child);
        if (slide != 0) {
          out = Transform.translate(
            offset: Offset(0, (1 - t) * slide),
            child: out,
          );
        }
        return out;
      },
      child: child,
    );
  }
}
