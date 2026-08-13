import 'package:flutter/material.dart';

import '../data/store.dart';
import '../utils/format.dart';
import '../theme/motion.dart';
import '../widgets/widgets.dart';

class LettureScreen extends StatelessWidget {
  const LettureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final groups = <String, List<dynamic>>{};
    for (final l in store.letture) {
      final key = dateShort.format(l.data);
      groups.putIfAbsent(key, () => []).add(l);
    }
    final keys = groups.keys.toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => pushApp(context, const LetturaBulkScreen()),
        icon: const Icon(Icons.playlist_add),
        label: const Text('Campagna letture'),
      ),
      body: SafeArea(
        child: store.letture.isEmpty
            ? EmptyState(
                icon: Icons.speed_outlined,
                title: 'Nessuna lettura',
                subtitle:
                    'Registra i contatori di tutte le unità in una volta sola. Il consumo si calcola sulla differenza rispetto alla lettura precedente.',
                actionLabel: 'Registra i contatori',
                onAction: () => pushApp(context, const LetturaBulkScreen()),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                children: [
                  MaxWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Letture contatori',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ogni campagna raccoglie il generale e i sottocontatori nella stessa data.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 18),
                        for (final k in keys)
                          _DayGroup(label: k, letture: groups[k]!.cast()),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _DayGroup extends StatelessWidget {
  const _DayGroup({required this.label, required this.letture});
  final String label;
  final List letture;

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final gen = letture.where((l) => l.isGenerale).toList();
    final altri = letture.where((l) => !l.isGenerale).toList();
    double somma = 0;
    for (final l in altri) {
      somma += l.valore as double;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleLarge),
            if (gen.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Generale ${mc(gen.first.valore)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: 8),
            for (final l in altri)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(
                        'int. ${store.unitaById(l.unitaId)?.interno ?? '—'}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        store.unitaById(l.unitaId)?.proprietario ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      mcNum(l.valore),
                      style: const TextStyle(
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(),
            Text(
              'Somma sottocontatori: ${mc(somma)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class LetturaBulkScreen extends StatefulWidget {
  const LetturaBulkScreen({super.key});

  @override
  State<LetturaBulkScreen> createState() => _LetturaBulkScreenState();
}

class _LetturaBulkScreenState extends State<LetturaBulkScreen> {
  late DateTime data;
  final generale = TextEditingController();
  final note = TextEditingController();
  final controllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    data = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final store = StoreScope.of(context);
    for (final u in store.unita) {
      controllers.putIfAbsent(u.id, TextEditingController.new);
    }
  }

  @override
  void dispose() {
    generale.dispose();
    note.dispose();
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final store = StoreScope.read(context);
    final valori = <String, double>{};
    for (final u in store.unita) {
      final v = parseItNumber(controllers[u.id]?.text ?? '');
      if (v != null) valori[u.id] = v;
    }
    if (valori.isEmpty) {
      showToast(context, 'Inserisci almeno una lettura');
      return;
    }
    await store.salvaCampagnaLetture(
      data: data,
      valori: valori,
      generale: parseItNumber(generale.text),
      note: note.text.trim().isEmpty ? null : note.text.trim(),
    );
    if (mounted) {
      showToast(context, 'Letture salvate');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Campagna letture')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          MaxWidth(
            width: 720,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  onTap: () async {
                    final d = await pickDate(context, initial: data);
                    if (d != null) setState(() => data = d);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.event,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Data della campagna'),
                            Text(
                              dateIt.format(data),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ItField(
                  label: 'Contatore generale (m³)',
                  controller: generale,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  hint: 'Lettura del contatore MM / gestore',
                ),
                const SizedBox(height: 18),
                const SectionLabel('Sottocontatori'),
                for (final u in store.unita)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        InternoAvatar(unita: u, size: 40),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                u.titolo,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                () {
                                  final prev = store.ultimaLetturaDi(u.id);
                                  return prev == null
                                      ? 'Nessuna lettura precedente'
                                      : 'Prec. ${mcNum(prev.valore)} · ${dateShort.format(prev.data)}';
                                }(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controllers[u.id],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              hintText: 'm³',
                              isDense: true,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                Builder(
                  builder: (context) {
                    var sum = 0.0;
                    var n = 0;
                    for (final u in store.unita) {
                      final v = parseItNumber(controllers[u.id]?.text ?? '');
                      if (v != null) {
                        sum += v;
                        n++;
                      }
                    }
                    final g = parseItNumber(generale.text);
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: Text(
                        n == 0
                            ? 'Inserisci le letture assolute, non i consumi.'
                            : 'Somma letture $n unità: ${mc(sum)}'
                                  '${g == null ? '' : ' · generale ${mc(g)}'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  },
                ),
                ItField(label: 'Note', controller: note),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: const Text('Salva campagna'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
