import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../design/design_tokens.dart';
import '../../core/providers/contact_provider.dart';

class ContactSection extends StatefulWidget {
  final VoidCallback? onRequestQuote;
  final VoidCallback? onDownloadBrochure;

  const ContactSection({super.key, this.onRequestQuote, this.onDownloadBrochure});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  // Contact data (change if needed)
  static const _phone = '+212 784007410';
  static const _email = 'contact@multisales.ma';
  static const _address = '49 boulevard CHEFCHAOUNI II, Ain Sébaâ, Casablanca Maroc';
  static const _hours = 'Lun–Ven 08:30 – 18:00';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: _phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnack('Impossible d’ouvrir l’application Téléphone.');
    }
  }

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {'subject': 'Demande depuis MULTISALES'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnack('Impossible d’ouvrir le client mail.');
    }
  }

  Future<void> _copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    _showSnack('$label copié dans le presse‑papier');
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ContactProvider>();

    final ok = await provider.submit(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      message: _messageCtrl.text.trim(),
    );

    if (ok) {
      _showSnack('Merci — votre message a été envoyé.');
      _formKey.currentState!.reset();
      _nameCtrl.clear();
      _emailCtrl.clear();
      _messageCtrl.clear();
    } else {
      _showSnack('Échec de l’envoi. Réessayez plus tard.');
    }
  }

  Widget _infoCard({required IconData icon, required String title, required Widget child, required VoidCallback? onTap}) {
    return Card(
      elevation: 0,
  color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: DesignTokens.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: DesignTokens.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                  ),
                  const SizedBox(height: 6),
                  child,
                ]),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withValues(alpha: 0.6) ??
                      Colors.black45,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final provider = context.watch<ContactProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
      child: Column(
        children: [
          Text(
            'Contactez‑nous',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Besoin d’un devis, d’un réassort ou d’informations produits ? Remplissez le formulaire ou utilisez les moyens de contact ci‑contre.',
            textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.color
              ?.withValues(alpha: 0.7) ??
            Colors.black54,
        ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(builder: (context, constraints) {
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _leftColumn()),
                  const SizedBox(width: 20),
                  Expanded(flex: 5, child: _rightFormCard(isLoading: provider.isLoading)),
                ],
              );
            } else {
              return Column(
                children: [
                  _leftColumn(),
                  const SizedBox(height: 16),
                  _rightFormCard(isLoading: provider.isLoading),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _leftColumn() {
    return Column(
      children: [
        _infoCard(
          icon: Icons.location_on_outlined,
          title: 'Adresse',
          child: Text(
            _address,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          onTap: () async {
            final query = Uri.encodeComponent(_address);
            final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
        ),
        const SizedBox(height: 10),
        _infoCard(
          icon: Icons.phone_outlined,
          title: 'Téléphone',
          child: Row(children: [
            SelectableText(
              _phone,
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
            const SizedBox(width: 8),
            IconButton(onPressed: _launchPhone, icon: const Icon(Icons.call, color: Colors.green)),
            IconButton(
              onPressed: () => _copyToClipboard(_phone, 'Numéro'),
              icon: Icon(
                Icons.copy,
                size: 18,
                color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.6) ??
                    Colors.black45,
              ),
            ),
          ]),
          onTap: _launchPhone,
        ),
        const SizedBox(height: 10),
        _infoCard(
          icon: Icons.email_outlined,
          title: 'Email',
          child: Row(children: [
            Flexible(
              child: SelectableText(
                _email,
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(onPressed: _launchEmail, icon: Icon(Icons.send, color: DesignTokens.primary)),
            IconButton(
              onPressed: () => _copyToClipboard(_email, 'Email'),
              icon: Icon(
                Icons.copy,
                size: 18,
                color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.6) ??
                    Colors.black45,
              ),
            ),
          ]),
          onTap: _launchEmail,
        ),
        const SizedBox(height: 10),
        _infoCard(
          icon: Icons.access_time_outlined,
          title: 'Horaires',
          child: Text(
            _hours,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          onTap: null,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.onRequestQuote,
                icon: const Icon(Icons.request_page),
                label: const Text('Demander un devis'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onDownloadBrochure,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Télécharger brochure (PDF)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: DesignTokens.primary,
                  side: BorderSide(color: DesignTokens.primary.withValues(alpha: 0.8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _rightFormCard({required bool isLoading}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('Envoyer un message', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nom et prénom', prefixIcon: Icon(Icons.person)),
              validator: (v) => (v == null || v.trim().length < 2) ? 'Veuillez renseigner votre nom' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Veuillez renseigner votre email';
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(v.trim())) return 'Email invalide';
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _messageCtrl,
              decoration: const InputDecoration(labelText: 'Message', prefixIcon: Icon(Icons.message)),
              maxLines: 6,
              validator: (v) => (v == null || v.trim().length < 10) ? 'Message trop court' : null,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: isLoading ? null : _submitForm,
              icon: isLoading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send),
              label: Text(isLoading ? 'Envoi...' : 'Envoyer le message'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 8),
            Text('Nous répondrons généralement sous 24–48h.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
          ]),
        ),
      ),
    );
  }
}
