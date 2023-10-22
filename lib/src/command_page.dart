import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_module_register/src/blue_page.dart';
import 'package:flutter_module_register/src/boost_main.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import 'app_localizations.dart';
import 'dialog_page.dart';
import 'lifecycle_test_page.dart';
import 'locale_notifier.dart';
import 'main_page.dart';
import 'replacement_page.dart';
import 'simple_page.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({super.key});

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
      ],
      child: Consumer<LocaleNotifier>(
        builder: (context, currentLocal, child) {
          return MaterialApp(
            home: const BluePage(),
            theme: ThemeData(colorScheme: const ColorScheme.light()),
            darkTheme: ThemeData(colorScheme: const ColorScheme.dark()),
            themeMode: ThemeMode.dark,
            debugShowCheckedModeBanner: true,
            locale: currentLocal.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate, // 指定本地化的字符串和一些其他的值
              GlobalCupertinoLocalizations.delegate, // 对应的Cupertino风格
              GlobalWidgetsLocalizations.delegate, // 指定默认的文本排列方向, 由左到右或由右到左
              AppLocale.delegate,
              S.delegate,
            ],
            supportedLocales: const [
              Locale.fromSubtags(languageCode: 'en'),
              Locale.fromSubtags(languageCode: 'zh'),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              debugPrint(locale.toString());
              debugPrint(supportedLocales.toString());
              if (supportedLocales.contains(locale)) {
                return locale;
              }
              return const Locale('zh');
            },
          );
        },
      ),
    );
    ;
  }
}
