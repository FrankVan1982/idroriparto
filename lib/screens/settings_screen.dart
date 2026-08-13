import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/store.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../theme/motion.dart';
import '../widgets/widgets.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final c = store.condominio!;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          MaxWidth(
            width: 720,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Impostazioni', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 18),
                const SectionLabel('Condominio'),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.nome, style: Theme.of(context).textTheme.titleLarge),
                      if (c.indirizzoCompleto.isNotEmpty) Text(c.indirizzoCompleto),
                      if (c.amministratore.isNotEmpty)
                        Text('Amm.: ${c.amministratore}'),
                      if (c.fornitore.isNotEmpty) Text('Gestore: ${c.fornitore}'),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => pushApp(context, const CondoFormScreen()),
                        child: const Text('Modifica anagrafica e criteri'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const SectionLabel('Aspetto'),
                AppCard(
                  child: LayoutBuilder(
                    builder: (context, box) {
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: box.maxWidth < 280 ? 280 : box.maxWidth,
                          child: SegmentedButton<ThemeChoice>(
                            showSelectedIcon: false,
                            segments: const [
                              ButtonSegment(
                                value: ThemeChoice.system,
                                label: Text('Sistema'),
                              ),
                              ButtonSegment(
                                value: ThemeChoice.light,
                                label: Text('Chiaro'),
                              ),
                              ButtonSegment(
                                value: ThemeChoice.dark,
                                label: Text('Scuro'),
                              ),
                            ],
                            selected: {store.themeChoice},
                            onSelectionChanged: (s) => store.setTheme(s.first),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                const SectionLabel('Archivio'),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.ios_share),
                        title: const Text('Esporta JSON'),
                        subtitle: const Text('Copia l’intero archivio negli appunti'),
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(
                              text: AppSnapshot(
                                condominio: store.condominio,
                                unita: store.unita,
                                letture: store.letture,
                                bollette: store.bollette,
                                riparti: store.riparti,
                                theme: store.themeChoice,
                              ).toPrettyJson(),
                            ),
                          );
                          if (context.mounted) {
                            showToast(context, 'Archivio copiato');
                          }
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.file_download_outlined),
                        title: const Text('Importa JSON'),
                        onTap: () => _import(context),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.auto_awesome),
                        title: const Text('Carica condominio di esempio'),
                        subtitle: const Text('Palazzo Solferino, Milano — sostituisce i dati attuali'),
                        onTap: () async {
                          final ok = await _confirm(
                            context,
                            'Sostituire i dati con l’esempio di Milano?',
                          );
                          if (ok && context.mounted) {
                            await StoreScope.read(context).loadDemo();
                          }
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.delete_forever_outlined, color: AppColors.coral),
                        title: const Text('Azzera tutto'),
                        onTap: () async {
                          final ok = await _confirm(
                            context,
                            'Cancellare condominio, unità, letture e bollette?',
                          );
                          if (ok && context.mounted) {
                            await StoreScope.read(context).resetAll();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const SectionLabel('Informazioni'),
                const AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IdroRiparto',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'App per la ripartizione delle spese idriche condominiali. '
                        'I calcoli seguono la prassi più diffusa in Italia: art. 1123 c.c. '
                        'in assenza di contatori, consumo effettivo quando i sottocontatori '
                        'sono installati, e criterio misto (quota fissa + m³ + parti comuni) '
                        'quando l’assemblea lo delibera.\n\n'
                        'I dati restano sul dispositivo. Non è un parere legale: il regolamento '
                        'contrattuale o una delibera possono imporre un criterio diverso.',
                      ),
                      SizedBox(height: 8),
                      Text('Versione 1.0.0'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirm(BuildContext context, String msg) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confermi?'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annulla')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Continua')),
        ],
      ),
    );
    return r == true;
  }

  Future<void> _import(BuildContext context) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Incolla l’archivio JSON'),
        content: SizedBox(
          width: 480,
          child: TextField(
            controller: ctrl,
            maxLines: 10,
            decoration: const InputDecoration(hintText: '{ … }'),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annulla')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Importa')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      try {
        final snap = AppSnapshot.fromJson(
          jsonDecode(ctrl.text) as Map<String, dynamic>,
        );
        await StoreScope.read(context).importSnapshot(snap);
        if (context.mounted) showToast(context, 'Archivio importato');
      } catch (e) {
        if (context.mounted) showToast(context, 'JSON non valido');
      }
    }
    ctrl.dispose();
  }
}

class CondoFormScreen extends StatefulWidget {
  const CondoFormScreen({super.key});

  @override
  State<CondoFormScreen> createState() => _CondoFormScreenState();
}

class _CondoFormScreenState extends State<CondoFormScreen> {
  late final TextEditingController nome;
  late final TextEditingController indirizzo;
  late final TextEditingController cap;
  late final TextEditingController citta;
  late final TextEditingController provincia;
  late final TextEditingController cf;
  late final TextEditingController ammin;
  late final TextEditingController fornitore;
  late final TextEditingController utenza;
  late final TextEditingController note;
  late MetodoRiparto metodo;
  late CriterioQuota fissa;
  late CriterioQuota comune;

  @override
  void initState() {
    super.initState();
    final c = StoreScope.read(context).condominio!;
    nome = TextEditingController(text: c.nome);
    indirizzo = TextEditingController(text: c.indirizzo);
    cap = TextEditingController(text: c.cap);
    citta = TextEditingController(text: c.citta);
    provincia = TextEditingController(text: c.provincia);
    cf = TextEditingController(text: c.codiceFiscale ?? '');
    ammin = TextEditingController(text: c.amministratore);
    fornitore = TextEditingController(text: c.fornitore);
    utenza = TextEditingController(text: c.codiceUtenza ?? '');
    note = TextEditingController(text: c.note);
    metodo = c.metodoDefault;
    fissa = c.criterioFissa;
    comune = c.criterioComune;
  }

  @override
  void dispose() {
    nome.dispose();
    indirizzo.dispose();
    cap.dispose();
    citta.dispose();
    provincia.dispose();
    cf.dispose();
    ammin.dispose();
    fornitore.dispose();
    utenza.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anagrafica condominio')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          MaxWidth(
            width: 640,
            child: Column(
              children: [
                ItField(label: 'Nome', controller: nome),
                const SizedBox(height: 10),
                ItField(label: 'Indirizzo', controller: indirizzo),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: ItField(label: 'CAP', controller: cap)),
                    const SizedBox(width: 10),
                    Expanded(flex: 2, child: ItField(label: 'Città', controller: citta)),
                    const SizedBox(width: 10),
                    Expanded(child: ItField(label: 'Prov.', controller: provincia)),
                  ],
                ),
                const SizedBox(height: 10),
                ItField(label: 'Codice fiscale / P. IVA', controller: cf),
                const SizedBox(height: 10),
                ItField(label: 'Amministratore', controller: ammin),
                const SizedBox(height: 10),
                ItField(label: 'Gestore idrico', controller: fornitore),
                const SizedBox(height: 10),
                ItField(label: 'Codice utenza', controller: utenza),
                const SizedBox(height: 10),
                ItField(label: 'Note', controller: note, maxLines: 3),
                const SizedBox(height: 16),
                DropdownButtonFormField<MetodoRiparto>(
                  // ignore: deprecated_member_use
                  value: metodo,
                  decoration: const InputDecoration(labelText: 'Metodo predefinito'),
                  items: [
                    for (final m in MetodoRiparto.values)
                      DropdownMenuItem(value: m, child: Text(m.titolo)),
                  ],
                  onChanged: (v) => setState(() => metodo = v ?? metodo),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<CriterioQuota>(
                  // ignore: deprecated_member_use
                  value: fissa,
                  decoration: const InputDecoration(labelText: 'Criterio quota fissa'),
                  items: [
                    for (final m in CriterioQuota.values)
                      DropdownMenuItem(value: m, child: Text(m.label)),
                  ],
                  onChanged: (v) => setState(() => fissa = v ?? fissa),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<CriterioQuota>(
                  // ignore: deprecated_member_use
                  value: comune,
                  decoration: const InputDecoration(labelText: 'Criterio parti comuni'),
                  items: [
                    for (final m in CriterioQuota.values)
                      DropdownMenuItem(value: m, child: Text(m.label)),
                  ],
                  onChanged: (v) => setState(() => comune = v ?? comune),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final cur = StoreScope.read(context).condominio!;
                      await StoreScope.read(context).saveCondominio(
                        cur.copyWith(
                          nome: nome.text.trim(),
                          indirizzo: indirizzo.text.trim(),
                          cap: cap.text.trim(),
                          citta: citta.text.trim(),
                          provincia: provincia.text.trim(),
                          codiceFiscale: cf.text.trim().isEmpty ? null : cf.text.trim(),
                          amministratore: ammin.text.trim(),
                          fornitore: fornitore.text.trim(),
                          codiceUtenza: utenza.text.trim().isEmpty ? null : utenza.text.trim(),
                          note: note.text.trim(),
                          metodoDefault: metodo,
                          criterioFissa: fissa,
                          criterioComune: comune,
                        ),
                      );
                      if (context.mounted) {
                        showToast(context, 'Condominio aggiornato');
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Salva'),
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
