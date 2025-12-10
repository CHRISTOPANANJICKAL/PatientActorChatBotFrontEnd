import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:symptomsphere/provider/common_provider.dart';
import 'package:symptomsphere/ui/base_window/base_window.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommonProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const BaseWindow(),
    );
  }
}
