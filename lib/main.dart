import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'viewmodels/task_viewmodel.dart';
import 'views/task_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jszbqzyavcetokrnifml.supabase.co',
    publishableKey: 'sb_publishable_DRPWqBaxqnzoNm1oN-hwkA_JDh3u1lk',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
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
      debugShowCheckedModeBanner: false,
      title: 'MVVM Supabase Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TaskView(),
    );
  }
}