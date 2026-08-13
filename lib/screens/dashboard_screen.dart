import 'package:flutter/material.dart';

import '../data/store.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../theme/motion.dart';
import '../utils/format.dart';
import '../widgets/widgets.dart';
import 'bollette_screens.dart';
import 'letture_screens.dart';
import 'riparto_screen.dart';
import 'unita_screens.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final c = store.condominio!;
    final last = store.ultimaBolletta;
    final rip = last == null ? null : store.ripartoDi(last.id);
    final scheme = Theme.of(context).colorScheme;
    final millOff =
        (store.sommaMillesimi - c.millesimiRiferimento).abs() > 0.05;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Material(
            color: scheme.primary,
            child: SafeArea(
              bottom: false,
              child: MaxWidth(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Appear(
                        child: Text(
                          greetingFor(DateTime.now()),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: scheme.onPrimary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Appear(
                        index: 1,
                        child: Text(
                          c.nome,
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(color: scheme.onPrimary),
                        ),
                      ),
                      if (c.indirizzoCompleto.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Appear(
                          index: 2,
                          child: Text(
                            c.indirizzoCompleto,
                            style: TextStyle(
                              color: scheme.onPrimary.withValues(alpha: 0.88),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Appear(
                        index: 3,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Quick(
                              icon: Icons.speed,
                              label: 'Nuova lettura',
                              onTap: () =>
                                  pushApp(context, const LetturaBulkScreen()),
                            ),
                            _Quick(
                              icon: Icons.receipt_long,
                              label: 'Nuova bolletta',
                              onTap: () =>
                                  pushApp(context, const BollettaFormScreen()),
                            ),
                            _Quick(
                              icon: Icons.add_home_work_outlined,
                              label: 'Aggiungi unità',
                              onTap: () =>
                                  pushApp(context, const UnitaFormScreen()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          sliver: SliverToBoxAdapter(
            child: MaxWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MetricGrid(
                    children: [
                      MetricTile(
                        label: 'Unità',
                        value: '${store.unita.length}',
                        hint: '${store.occupantiTotali} occupanti',
                        icon: Icons.apartment,
                      ),
                      MetricTile(
                        label: 'Millesimi',
                        value: mill(store.sommaMillesimi),
                        hint: millOff
                            ? 'Attesi ${mill(c.millesimiRiferimento)}'
                            : 'Allineati a ${mill(c.millesimiRiferimento)}',
                        icon: Icons.pie_chart_outline,
                        tone: millOff ? scheme.error : scheme.primary,
                      ),
                      MetricTile(
                        label: 'Ultima bolletta',
                        value: last == null ? '—' : euro(last.totale),
                        hint: last == null
                            ? 'Nessuna registrata'
                            : periodLabel(last.periodoDal, last.periodoAl),
                        icon: Icons.payments_outlined,
                        tone: scheme.tertiary,
                      ),
                      MetricTile(
                        label: 'Metodo',
                        value: c.metodoDefault.label,
                        hint: 'Predefinito del condominio',
                        icon: Icons.balance,
                        tone: scheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  if (rip != null && last != null) ...[
                    SectionLabel(
                      'Ultimo riparto',
                      trailing: TextButton(
                        onPressed: () =>
                            pushApp(context, RipartoScreen(bollettaId: last.id)),
                        child: const Text('Apri prospetto'),
                      ),
                    ),
                    Appear(
                      child: AppCard(
                        onTap: () =>
                            pushApp(context, RipartoScreen(bollettaId: last.id)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    periodLabel(
                                      last.periodoDal,
                                      last.periodoAl,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                StatoChip(last.stato),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${last.metodo.titolo} · ${last.fornitore.isEmpty ? c.fornitore : last.fornitore}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 16),
                            ShareBar(
                              parts: [
                                for (final r in rip.righe)
                                  (
                                    color: SchemeInk.forUnit(
                                      scheme,
                                      r.unitaId,
                                    ),
                                    value: r.totale,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 18,
                              runSpacing: 8,
                              children: [
                                _kv(context, 'Totale', euro(rip.totaleGenerale)),
                                _kv(context, 'Consumi', mc(rip.sommaConsumi)),
                                _kv(
                                  context,
                                  'Parti comuni',
                                  mc(rip.consumoComune),
                                ),
                                _kv(context, '€ / m³', euro(rip.prezzoMedioMc)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                  if (store.bollette.isNotEmpty) ...[
                    const SectionLabel('Andamento delle bollette'),
                    Appear(
                      child: AppCard(
                        child: _BillsBars(
                          bollette: store.bollette
                              .take(6)
                              .toList()
                              .reversed
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                  const SectionLabel('Come funziona il riparto misto'),
                  const Appear(
                    child: AppCard(
                      child: Column(
                        children: [
                          _How(
                            n: '1',
                            t: 'Quote fisse',
                            d: 'Canone e nolo contatore si dividono per millesimi, parti uguali o occupanti.',
                          ),
                          SizedBox(height: 16),
                          _How(
                            n: '2',
                            t: 'Consumi individuali',
                            d: 'Acquedotto, fognatura e depurazione seguono i m³ di ciascun sottocontatore.',
                          ),
                          SizedBox(height: 16),
                          _How(
                            n: '3',
                            t: 'Parti comuni e perdite',
                            d: 'La differenza tra contatore generale e somma dei sottocontatori si spalmano sullo stabile.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
        Text(
          v,
          style: const TextStyle(fontVariations: [FontVariation('wght', 680)]),
        ),
      ],
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton.tonal(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: scheme.onPrimary.withValues(alpha: 0.16),
        foregroundColor: scheme.onPrimary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _How extends StatelessWidget {
  const _How({required this.n, required this.t, required this.d});
  final String n;
  final String t;
  final String d;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: scheme.primaryContainer,
          child: Text(
            n,
            style: TextStyle(
              color: scheme.onPrimaryContainer,
              fontVariations: const [FontVariation('wght', 680)],
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t,
                style: const TextStyle(
                  fontVariations: [FontVariation('wght', 680)],
                ),
              ),
              Text(d, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _BillsBars extends StatelessWidget {
  const _BillsBars({required this.bollette});
  final List<Bolletta> bollette;

  @override
  Widget build(BuildContext context) {
    final maxV = bollette
        .map((b) => b.totale)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 188,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < bollette.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        euro(bollette[i].totale),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 10,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0.04,
                          end: maxV <= 0
                              ? 0.08
                              : (bollette[i].totale / maxV).clamp(0.08, 1),
                        ),
                        duration: AppMotion.of(
                          context,
                          Duration(milliseconds: 520 + i * 70),
                        ),
                        curve: AppMotion.spatial,
                        builder: (context, t, _) {
                          return FractionallySizedBox(
                            heightFactor: t,
                            widthFactor: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: scheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormatMini.fmt(bollette[i].periodoAl),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DateFormatMini {
  static String fmt(DateTime d) {
    const m = [
      'gen', 'feb', 'mar', 'apr', 'mag', 'giu',
      'lug', 'ago', 'set', 'ott', 'nov', 'dic',
    ];
    return '${m[d.month - 1]} ${d.year % 100}';
  }
}
