import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../theme/app_text_styles.dart';

class IdiomaSelectorScreen extends StatelessWidget {
  const IdiomaSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final idiomaActual = languageProvider.selectedLanguage;

    return Scaffold(
      appBar: AppBar(title: Text(languageProvider.translate('select_language_title'))),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: LanguageProvider.supportedLanguages.length,
        itemBuilder: (context, index) {
          final idioma = LanguageProvider.supportedLanguages[index];
          return ListTile(
            title: Text(idioma.nombre, style: AppTextStyles.cuerpo),
            subtitle: Text(idioma.codigo),
            trailing: idioma.idiomaID == idiomaActual.idiomaID
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () async {
              await languageProvider.setLanguage(idioma);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
