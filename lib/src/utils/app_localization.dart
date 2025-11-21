import 'package:flutter/material.dart';import 'package:flutter/foundation.dart';

class AppLocalizations {
AppLocalizations(this.locale);
 final Locale locale;
 
 static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
 
 static const _localizedValues = {
    'en': {
      'rowsPerPage': 'Rows per page',
    },
    'fr': {
      'rowsPerPage': 'Lignes par page',
    },
  };

  String get rowsPerPage {
    return _localizedValues[locale.languageCode]!['rowsPerPage']!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
