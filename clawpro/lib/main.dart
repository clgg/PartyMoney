import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/recharge_screen.dart';
import 'screens/consume_screen.dart';
import 'screens/history_screen.dart';
import 'screens/members_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '干饭基金',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/recharge': (context) => const RechargeScreen(),
        '/consume': (context) => const ConsumeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/members': (context) => const MembersScreen(),
      },
    );
  }
}
