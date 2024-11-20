import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Pages/home_page.dart';
import 'package:todoapp/Providers/provider.dart';
import 'package:todoapp/Themes/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Services(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Give My Task',
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: kSilver,
              ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
