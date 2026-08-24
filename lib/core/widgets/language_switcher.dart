import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget for switching between languages
class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.arrow_drop_down, size: 20),
      tooltip: l10n?.changeLanguage ?? 'Change Language',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onSelected: (Locale locale) {
        localeNotifier.changeLanguage(locale);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            children: [
              if (currentLocale.languageCode == 'en')
                const Icon(Icons.check, size: 18)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              const Text('English'),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('ar'),
          child: Row(
            children: [
              if (currentLocale.languageCode == 'ar')
                const Icon(Icons.check, size: 18)
              else
                const SizedBox(width: 18),
              const SizedBox(width: 8),
              const Text('العربية'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Simple language toggle button
class LanguageToggleButton extends ConsumerWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final localeNotifier = ref.read(localeProvider.notifier);

    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: l10n?.changeLanguage ?? 'Change Language',
      onPressed: () {
        localeNotifier.toggleLanguage();
      },
    );
  }
}

