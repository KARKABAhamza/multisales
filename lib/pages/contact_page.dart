// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../presentation/widgets/sarlau_app_bar.dart';
import '../presentation/widgets/sarlau_footer.dart';
import '../core/providers/contact_provider.dart';
import '../design/design_tokens.dart';
import '../l10n/app_localizations.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String email = '';
  // Stable subject key independent of localization
  String subject = 'general';
  String message = '';
  final _emailReg = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");

  String _subjectLabel(AppLocalizations t, String key) {
    switch (key) {
      case 'support':
        return t.subjectSupport;
      case 'sales':
        return t.subjectSales;
      case 'general':
      default:
        return t.subjectGeneral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: const SarlauAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Contact Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: DesignTokens.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DesignTokens.primary.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.menuContact, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    t.contactHeroSubtitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Two-Column Layout
            Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Contact Form
                Expanded(
                  flex: 3,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.black12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.mark_email_unread_outlined, color: DesignTokens.primary),
                                const SizedBox(width: 8),
                                Text(t.contactFormTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: '${t.firstName} / ${t.lastName}',
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              onSaved: (v) => fullName = v?.trim() ?? '',
                              validator: (v) => (v == null || v.trim().isEmpty) ? t.pleaseEnterFirstName : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: t.email,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (v) => email = v?.trim() ?? '',
                              validator: (v) => (v == null || !_emailReg.hasMatch(v)) ? t.pleaseEnterValidEmail : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: (() {
                                final keys = <String>['general', 'support', 'sales'];
                                return keys.contains(subject) ? subject : keys.first;
                              })(),
                              decoration: InputDecoration(
                                labelText: t.contactSubject,
                                prefixIcon: const Icon(Icons.topic_outlined),
                              ),
                              items: <Map<String, String>>[
                                    {'key': 'general', 'label': t.subjectGeneral},
                                    {'key': 'support', 'label': t.subjectSupport},
                                    {'key': 'sales', 'label': t.subjectSales},
                                  ]
                                  .map((m) => DropdownMenuItem(
                                        value: m['key'],
                                        child: Text(m['label']!),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => subject = v ?? 'general'),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: t.contactMessage,
                                prefixIcon: const Icon(Icons.chat_outlined),
                              ),
                              maxLines: 6,
                              onSaved: (v) => message = v?.trim() ?? '',
                              validator: (v) => (v == null || v.trim().isEmpty) ? t.pleaseEnterMessage : null,
                            ),
                            const SizedBox(height: 16),
                            Consumer<ContactProvider>(
                              builder: (context, provider, _) => ElevatedButton.icon(
                                onPressed: provider.isLoading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState?.validate() ?? false) {
                                          _formKey.currentState?.save();
                                          final ok = await context
                                              .read<ContactProvider>()
                                                .submit(
                                                  name: fullName,
                                                  email: email,
                                                  message: '[${_subjectLabel(t, subject)}] $message');
                                          if (!mounted) return;
                                          if (ok) {
                                            _formKey.currentState?.reset();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(t.contactSent)),
                                            );
                                          } else if (provider.errorMessage != null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(provider.errorMessage!)),
                                            );
                                          }
                                        }
                                      },
                                icon: provider.isLoading
                                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Icon(Icons.send_outlined),
                                label: Text(t.contactSend),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),

                // Right: Contact Info / Map
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _InfoCards(t: t),
                      const SizedBox(height: 12),
                      _WorkingHours(t: t),
                      const SizedBox(height: 12),
                      _MapCard(),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            const SarlauFooter(),
          ],
        ),
      ),
    );
  }
}

class _InfoCards extends StatelessWidget {
  final AppLocalizations t;
  const _InfoCards({required this.t});
  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        icon: Icons.location_on_outlined,
        title: t.locationTitle,
        subtitle: '49 boulevard CHEFCHAOUNI II, Ain Sebâa Casablanca'
      ),
      (
        icon: Icons.email_outlined,
        title: t.email,
        subtitle: 'contact@multisales.com'
      ),
      (
        icon: Icons.phone_outlined,
        title: t.phone,
        subtitle: '+212 6 12 34 56 78'
      ),
    ];
    return Row(
      children: cards
          .map((c) => Expanded(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black12)),
                  child: ListTile(
                    leading: Icon(c.icon, color: DesignTokens.primary),
                    title: Text(c.title),
                    subtitle: Text(c.subtitle),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _WorkingHours extends StatelessWidget {
  final AppLocalizations t;
  const _WorkingHours({required this.t});
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(Icons.access_time, color: DesignTokens.primary), const SizedBox(width: 8), Text(t.businessHoursTitle, style: Theme.of(context).textTheme.titleMedium)]),
            const SizedBox(height: 8),
            Text('Lun–Ven: 09:00 – 18:00', style: style),
            Text('Sam: 09:00 – 13:00', style: style),
            Text('Dim: ${t.closedLabel}', style: style),
          ],
        ),
      ),
    );
  }
}

// Social icons moved to SarlauFooter

Future<void> _open(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _MapCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black12)),
      child: InkWell(
        onTap: () => _open('https://www.google.com/maps?q=49%20boulevard%20CHEFCHAOUNI%20II%20Ain%20Seb%C3%A2a%20Casablanca'),
        child: Container(
          height: 240,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.map_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('Open interactive map', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
