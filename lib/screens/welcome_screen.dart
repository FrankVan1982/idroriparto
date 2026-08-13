import 'package:flutter/material.dart';

import '../data/store.dart';
import '../models/models.dart';
import '../theme/motion.dart';
import '../utils/ids.dart';
import '../widgets/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _indirizzo = TextEditingController();
  final _citta = TextEditingController();
  final _cap = TextEditingController();
  final _ammin = TextEditingController();
  MetodoRiparto _metodo = MetodoRiparto.misto;
  bool _busy = false;

  @override
  void dispose() {
    _nome.dispose();
    _indirizzo.dispose();
    _citta.dispose();
    _cap.dispose();
    _ammin.dispose();
    super.dispose();
  }

  Future<void> _demo() async {
    setState(() => _busy = true);
    AppMotion.impact();
    await StoreScope.read(context).loadDemo();
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _create() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    AppMotion.impact();
    final c = Condominio(
      id: newId('cnd'),
      nome: _nome.text.trim(),
      indirizzo: _indirizzo.text.trim(),
      citta: _citta.text.trim(),
      cap: _cap.text.trim(),
      amministratore: _ammin.text.trim(),
      metodoDefault: _metodo,
    );
    await StoreScope.read(context).saveCondominio(c);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final hero = _HeroPanel(onDemo: _busy ? null : _demo, fill: wide);
    final form = _FormPanel(
      form: _form,
      nome: _nome,
      indirizzo: _indirizzo,
      citta: _citta,
      cap: _cap,
      ammin: _ammin,
      metodo: _metodo,
      busy: _busy,
      onMetodo: (m) => setState(() => _metodo = m),
      onCreate: _create,
      onDemo: _demo,
    );

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(child: hero),
            Expanded(child: form),
          ],
        ),
      );
    }
    return Scaffold(
      body: ListView(
        children: [hero, form],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({this.onDemo, this.fill = false});
  final VoidCallback? onDemo;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final content = SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
          children: [
            const Appear(child: LogoMark(size: 72)),
            if (fill) const Spacer() else const SizedBox(height: 28),
            Appear(
              index: 1,
              child: Text(
                'L’acqua del condominio,\nripagata con chiarezza.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColorsSafe.onHero,
                  fontSize: 34,
                  height: 1.12,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Appear(
              index: 2,
              child: Text(
                'Millesimi, sottocontatori, quote fisse e parti comuni. '
                'Un prospetto pronto per l’assemblea, in un’app che resta sul dispositivo.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColorsSafe.onHeroMuted,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Appear(
              index: 3,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _Tag('Art. 1123 c.c.'),
                  _Tag('Quota mista'),
                  _Tag('Prospetto PDF'),
                  _Tag('Confronto metodi'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Appear(
              index: 4,
              child: FilledButton.tonal(
                onPressed: onDemo,
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                ),
                child: const Text('Apri l’esempio di Milano'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    return ColoredBox(
      color: const Color(0xFF0B3D42),
      child: Stack(
        fit: fill ? StackFit.expand : StackFit.loose,
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WaterRibbon(height: 72, light: false),
          ),
          fill ? Positioned.fill(child: content) : content,
        ],
      ),
    );
  }
}

class AppColorsSafe {
  static const onHero = Color(0xFFF7F3EA);
  static const onHeroMuted = Color(0xFFE4DDD0);
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x22F7F3EA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFF7F3EA),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({
    required this.form,
    required this.nome,
    required this.indirizzo,
    required this.citta,
    required this.cap,
    required this.ammin,
    required this.metodo,
    required this.busy,
    required this.onMetodo,
    required this.onCreate,
    required this.onDemo,
  });

  final GlobalKey<FormState> form;
  final TextEditingController nome;
  final TextEditingController indirizzo;
  final TextEditingController citta;
  final TextEditingController cap;
  final TextEditingController ammin;
  final MetodoRiparto metodo;
  final bool busy;
  final ValueChanged<MetodoRiparto> onMetodo;
  final VoidCallback onCreate;
  final VoidCallback onDemo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
            child: Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Appear(
                    child: Text(
                      'Crea il tuo condominio',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Appear(
                    index: 1,
                    child: Text(
                      'Potrai aggiungere le unità e le letture subito dopo. I dati restano solo su questo dispositivo.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ItField(
                    label: 'Nome del condominio',
                    controller: nome,
                    hint: 'es. Palazzo Solferino',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Obbligatorio' : null,
                  ),
                  const SizedBox(height: 12),
                  ItField(label: 'Indirizzo', controller: indirizzo),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: ItField(label: 'CAP', controller: cap)),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ItField(label: 'Città', controller: citta),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ItField(
                    label: 'Amministratore (facoltativo)',
                    controller: ammin,
                  ),
                  const SizedBox(height: 20),
                  const SectionLabel('Criterio di default'),
                  for (final m in MetodoRiparto.values)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AnimatedContainer(
                        duration: AppMotion.of(context, AppMotion.dSpatial),
                        curve: AppMotion.spatial,
                        decoration: BoxDecoration(
                          color: metodo == m
                              ? scheme.secondaryContainer
                              : scheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(
                            metodo == m ? 28 : 20,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () {
                            AppMotion.tap();
                            onMetodo(m);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Icon(
                                  metodo == m
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: metodo == m
                                      ? scheme.onSecondaryContainer
                                      : scheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.titolo,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: metodo == m
                                              ? scheme.onSecondaryContainer
                                              : scheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        m.descrizione,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: metodo == m
                                                  ? scheme.onSecondaryContainer
                                                  : scheme.onSurfaceVariant,
                                            ),
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
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: busy ? null : onCreate,
                      child: Text(busy ? 'Un attimo…' : 'Inizia'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: busy ? null : onDemo,
                      child: const Text('Meglio vedere un esempio'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
