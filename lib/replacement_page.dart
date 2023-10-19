import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_module_register/navigator.dart';

class ReplacementPage extends StatefulWidget {
  const ReplacementPage({Key? key}) : super(key: key);

  @override
  State createState() => _ReplacementPageState();
}

class _ReplacementPageState extends State<ReplacementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoButton.filled(
            child: const Text('back'),
            onPressed: () {
              Chief.pop();
            }),
      ),
    );
  }
}
