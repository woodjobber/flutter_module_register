import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_localizations.dart';
import 'locale_notifier.dart';

class BluePage extends StatelessWidget {
  const BluePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(AppLocale.current.title),
        ),
        body: Container(
          color: Colors.lightBlue,
          child: Center(
            child: ElevatedButton(
                child: const Text('切换语言'),
                onPressed: () {
                  final dialog = SimpleDialog(
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          context.read<LocaleNotifier>().updateLanguage('zh');
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(AppLocale.current.settingLanguageChinese),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          context.read<LocaleNotifier>().updateLanguage('en');
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(AppLocale.current.settingLanguageEnglish),
                        ),
                      ),
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (ctx) => dialog,
                  );
                }),
          ),
        ),
      ),
    );
  }
}
