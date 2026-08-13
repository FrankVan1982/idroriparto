import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';
import '../theme/motion.dart';
import '../utils/format.dart';

class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 56});
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.28),
      child: Image.asset(
        'assets/brand/logo_source.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                letterSpacing: 1.05,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final card = Card.filled(
      color: color ?? Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          AppMotion.tap();
          onTap!();
        },
        child: card,
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    this.hint,
    this.icon,
    this.tone,
  });

  final String label;
  final String value;
  final String? hint;
  final IconData? icon;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = tone ?? scheme.primary;
    return AppCard(
      color: scheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 18, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: c,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(
              hint!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class MetricGrid extends StatelessWidget {
  const MetricGrid({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final cols = box.maxWidth > 720 ? 4 : 2;
        const gap = 12.0;
        final w = (box.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < children.length; i++)
              Appear(
                index: i,
                child: SizedBox(width: w, child: children[i]),
              ),
          ],
        );
      },
    );
  }
}

class MoneyText extends StatelessWidget {
  const MoneyText(
    this.amount, {
    super.key,
    this.style,
    this.color,
    this.big = false,
  });
  final num amount;
  final TextStyle? style;
  final Color? color;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final base = big
        ? Theme.of(context).textTheme.headlineMedium
        : Theme.of(context).textTheme.titleMedium;
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Text(
        euro(amount),
        maxLines: 1,
        style: (style ?? base)?.copyWith(
          color: color ?? Theme.of(context).colorScheme.onSurface,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class InternoAvatar extends StatelessWidget {
  const InternoAvatar({super.key, required this.unita, this.size = 44});
  final UnitaImmobiliare unita;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = SchemeInk.forUnit(scheme, unita.id);
    return AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.dSpatial),
      curve: AppMotion.spatial,
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(size * 0.34),
      ),
      child: Text(
        unita.interno,
        maxLines: 1,
        style: TextStyle(
          color: c,
          fontSize: size * 0.34,
          fontVariations: const [FontVariation('wght', 680)],
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });
  final String label;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = color ?? scheme.primary;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 28),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: c),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: c,
                    fontSize: 12,
                    fontVariations: const [FontVariation('wght', 580)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WarningBanner extends StatelessWidget {
  const WarningBanner({super.key, required this.messages});
  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.tertiaryContainer,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: scheme.onTertiaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Da verificare',
                    style: TextStyle(
                      color: scheme.onTertiaryContainer,
                      fontVariations: const [FontVariation('wght', 680)],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final m in messages)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '· $m',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onTertiaryContainer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Appear(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Icon(icon, size: 34, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 20),
                  FilledButton(onPressed: onAction, child: Text(actionLabel!)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItField extends StatelessWidget {
  const ItField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.suffix,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? suffix;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      onChanged: onChanged,
      enabled: enabled,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      ),
    );
  }
}

class ShareBar extends StatelessWidget {
  const ShareBar({super.key, required this.parts});
  final List<({Color color, double value})> parts;

  @override
  Widget build(BuildContext context) {
    final tot = parts.fold<double>(0, (a, b) => a + b.value);
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 14,
        child: Row(
          children: [
            for (final p in parts)
              if (p.value > 0)
                Expanded(
                  flex: (p.value / (tot <= 0 ? 1 : tot) * 1000).round().clamp(
                    1,
                    1000,
                  ),
                  child: AnimatedContainer(
                    duration: AppMotion.of(context, AppMotion.dSpatial),
                    curve: AppMotion.spatial,
                    color: p.color,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class UnitShareChart extends StatelessWidget {
  const UnitShareChart({super.key, required this.righe});
  final List<RigaRiparto> righe;

  @override
  Widget build(BuildContext context) {
    if (righe.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final maxV = righe
        .map((e) => e.totale)
        .fold<double>(0, (a, b) => a > b ? a : b);
    return Column(
      children: [
        for (var i = 0; i < righe.length; i++)
          Appear(
            index: i,
            slide: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      righe[i].interno,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontVariations: [FontVariation('wght', 680)],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0,
                        end: maxV <= 0
                            ? 0
                            : (righe[i].totale / maxV).clamp(0, 1),
                      ),
                      duration: AppMotion.of(context, AppMotion.dSlow),
                      curve: AppMotion.spatialEmphasized,
                      builder: (context, t, _) {
                        return Stack(
                          children: [
                            Container(
                              height: 22,
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: t,
                              child: Container(
                                height: 22,
                                decoration: BoxDecoration(
                                  color: SchemeInk.forUnit(
                                    scheme,
                                    righe[i].unitaId,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 84,
                    child: Text(
                      euro(righe[i].totale),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontFeatures: [FontFeature.tabularFigures()],
                        fontVariations: [FontVariation('wght', 580)],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class StatoChip extends StatelessWidget {
  const StatoChip(this.stato, {super.key});
  final StatoBolletta stato;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (stato) {
      StatoBolletta.bozza => scheme.onSurfaceVariant,
      StatoBolletta.calcolata => scheme.primary,
      StatoBolletta.chiusa => scheme.tertiary,
    };
    return StatusPill(label: stato.label, color: color);
  }
}

Future<DateTime?> pickDate(
  BuildContext context, {
  DateTime? initial,
  DateTime? first,
  DateTime? last,
}) {
  final now = DateTime.now();
  return showDatePicker(
    context: context,
    initialDate: initial ?? now,
    firstDate: first ?? DateTime(now.year - 12),
    lastDate: last ?? DateTime(now.year + 2),
    locale: const Locale('it', 'IT'),
  );
}

void showToast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class MaxWidth extends StatelessWidget {
  const MaxWidth({super.key, required this.child, this.width = 1120});
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: child,
      ),
    );
  }
}
