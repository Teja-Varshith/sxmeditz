import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 960;

    final copy = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Kicker('Work with me', light: true),
          SectionTitle(
            "Let's make your content ",
            highlight: 'impossible to skip.',
            color: Colors.white,
            size: context.responsive(mobile: 40.0, tablet: 54.0, desktop: 68.0),
          ),
          const SizedBox(height: 24),
          Text(
            "Tell me a bit about your project and I'll get back to you within 24 hours.",
            style: AppText.body(size: 18, color: Colors.white70),
          ),
          const SizedBox(height: 40),
          _ContactLink(
            label: contactEmail,
            icon: Icons.mail_outline_rounded,
            onTap: () => openUrl('mailto:$contactEmail'),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final s in socials)
                AppButton(
                  label: s.label,
                  small: true,
                  variant: ButtonVariant.ghost,
                  onDark: true,
                  onPressed: () => openUrl(s.url),
                ),
            ],
          ),
        ],
      ),
    );

    return Section(
      color: AppColors.ink,
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: copy),
                const SizedBox(width: 72),
                const Expanded(child: Reveal(child: _ContactForm())),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                copy,
                const SizedBox(height: 48),
                const Reveal(child: _ContactForm()),
              ],
            ),
    );
  }
}

class _ContactLink extends StatelessWidget {
  const _ContactLink({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.blue),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              style: AppText.display(
                size: context.responsive(mobile: 20.0, desktop: 26.0),
                color: Colors.white,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  String _service = serviceOptions.first;
  String? _status;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  /// No backend yet: opens the visitor's email app with the details filled in.
  /// Swap for Formspree / Firebase / EmailJS later if the client wants
  /// submissions without an email app.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final uri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      query: _encode({
        'subject': 'New project enquiry — $_service',
        'body':
            'Name: ${_name.text}\nEmail: ${_email.text}\nService: $_service\n\n${_message.text}',
      }),
    );
    final ok = await launchUrl(uri);
    setState(
      () => _status = ok
          ? 'Opening your email app… If nothing happens, email $contactEmail directly.'
          : 'Could not open your email app. Please email $contactEmail directly.',
    );
  }

  String _encode(Map<String, String> params) => params.entries
      .map(
        (e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
      )
      .join('&');

  InputDecoration _decoration(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: AppColors.bg2,
    labelStyle: AppText.body(size: 15, color: AppColors.ink2),
    floatingLabelStyle: AppText.body(
      size: 15,
      weight: FontWeight.w700,
      color: AppColors.blueInk,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.blue, width: 2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final textStyle = AppText.body(
      size: 16,
      color: AppColors.ink,
      weight: FontWeight.w600,
    );

    return Container(
      padding: EdgeInsets.all(context.responsive(mobile: 22.0, desktop: 36.0)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _name,
              style: textStyle,
              decoration: _decoration('Your name'),
              autofillHints: const [AutofillHints.name],
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _email,
              style: textStyle,
              decoration: _decoration('Email'),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Please enter your email';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value))
                  return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _service,
              style: textStyle,
              decoration: _decoration('What do you need?'),
              borderRadius: BorderRadius.circular(14),
              dropdownColor: Colors.white,
              items: [
                for (final s in serviceOptions)
                  DropdownMenuItem(value: s, child: Text(s)),
              ],
              onChanged: (v) => setState(() => _service = v ?? _service),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _message,
              style: textStyle,
              minLines: 4,
              maxLines: 6,
              decoration: _decoration(
                'Project details',
                hint: 'Your channel or brand, goals, timeline…',
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Send message',
              arrow: true,
              expand: true,
              onPressed: _submit,
            ),
            if (_status != null) ...[
              const SizedBox(height: 14),
              Semantics(
                liveRegion: true,
                child: Text(
                  _status!,
                  style: AppText.body(size: 14, color: AppColors.ink2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
