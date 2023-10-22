import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_module_register/src/app_localizations.dart';
import 'package:flutter_module_register/src/locale_notifier.dart';
import 'package:flutter_module_register/src/navigator.dart';
import 'package:provider/provider.dart';

class Model {
  Model(this.title, this.onTap);

  String title;
  VoidCallback onTap;
}

class MainPage extends StatefulWidget {
  final String? data;

  const MainPage({Key? key, this.data}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final TextEditingController _controller = TextEditingController();

  GlobalKey<ScaffoldState> key = GlobalKey();

  VoidCallback? removeListener;

  ValueNotifier<bool> withContainer = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    ///这里添加监听，原生利用`event`这个key发送过来消息的时候，下面的函数会调用，
    ///这里就是简单的在flutter上弹一个弹窗
    removeListener = BoostChannel.instance.addEventListener("toFlutterEvent",
        (key, arguments) {
      Logger.log(arguments.toString());
      OverlayEntry entry = OverlayEntry(builder: (_) {
        return Center(
            child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(4)),
            child: Text('这是native传来的参数：${arguments.toString()}',
                style: const TextStyle(color: Colors.white)),
          ),
        ));
      });

      Overlay.of(context).insert(entry);

      Future.delayed(const Duration(seconds: 2), () {
        entry.remove();
      });
      return Future(() {});
    });
  }

  @override
  void dispose() {
    ///记得解除注册
    removeListener?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    ///Focus on code below to know the basic API
    ///大家重点关注这个Model里面各个API的调用，其他的都是UI的布局可以不用看
    ///
    final List<Model> models = [
      Model("open native page", () {
        Chief.push("homePage", arguments: {'data': _controller.text})
            .then((value) => showTipIfNeeded(value.toString()));
      }),
      Model("return to native page with data", () {
        Map<String, Object> result = {'data': _controller.text};
        Chief.pop(result);
      }),
      Model("open flutter main page", () {
        Chief.push("mainPage",
                withContainer: withContainer.value,
                arguments: {'data': _controller.text})
            .then((value) => showTipIfNeeded(value.toString()));
      }),
      Model("open flutter simple page", () {
        Chief.push("simplePage",
                withContainer: withContainer.value,
                arguments: {'data': _controller.text})
            .then((value) => showTipIfNeeded(value.toString()));
      }),
      Model("push with flutter Navigator", () {
        Navigator.of(context)
            .pushNamed('simplePage', arguments: {'data': _controller.text});
      }),
      Model("show dialog", () {
        showDialog(
            context: context,
            builder: (_) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 100,
                    width: 100,
                    color: Colors.redAccent,
                    child: const Material(
                      child: Text('this is a dialog',
                          style: TextStyle(fontSize: 25)),
                    ),
                  ),
                ),
              );
            });
      }),
      Model("open lifecycle test page", () {
        Chief.push(
          "lifecyclePage",
          withContainer: withContainer.value,
        );
      }),
      Model("push replacement with Container", () {
        Chief.pushReplacement(
          "replacementPage",
          withContainer: withContainer.value,
        );
      }),
      Model("open dialog with container", () {
        Chief.push("dialogPage",
            withContainer: true,

            ///如果开启新容器，需要指定opaque为false
            opaque: false);
      }),
      Model("send event to native", () {
        ///传值给原生
        BoostChannel.instance
            .sendEventToNative("event", {'data': "event from flutter"});
        Chief.pop();
      }),
    ];

    ///You don't need to take care about the code below
    ///你不需要关心下面的UI代码
    ///==========================================================
    stdout.writeln("mainPage....");
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: key,
        appBar: CupertinoNavigationBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).primaryColor,
          trailing: ElevatedButton(
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
          leading: CupertinoNavigationBarBackButton(
            onPressed: () {
              Chief.pop();
            },
          ),
          middle: Text(
            AppLocale.current.title,
            style: TextStyle(color: Theme.of(context).primaryColorLight),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            emptyBox(0, 50),
            _buildHeader(),
            emptyBox(0, 30),
            SliverToBoxAdapter(
                child: Center(
              child: Text('Data String is: ${widget.data}',
                  style: const TextStyle(fontSize: 30)),
            )),
            emptyBox(0, 30),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (ctx, index) => item(models[index]),
                    childCount: models.length)),
            emptyBox(0, 50),
          ],
        ),
      ),
    );
  }

  Widget emptyBox(double width, double height) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: width,
        height: height,
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoTextField(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          controller: _controller,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.amber),
          placeholder: 'input data ',
          placeholderStyle: const TextStyle(color: Colors.black38),
        ),
      ),
    );
  }

  Widget item(Model model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(vertical: 15),
        onPressed: model.onTap,
        child: Text(model.title,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  void showTipIfNeeded(String value) {
    if (value == 'null' || value.isEmpty) {
      return;
    }
    final bar = SnackBar(
        content: Text('return value is $value'),
        duration: const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  Widget _buildBottomBar() {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'with container',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: withContainer,
            builder: (BuildContext context, value, Widget? child) {
              return CupertinoSwitch(
                  value: value,
                  onChanged: (newValue) {
                    withContainer.value = newValue;
                  });
            },
          ),
        ],
      ),
    );
  }
}
