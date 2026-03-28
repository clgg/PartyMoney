import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        primaryColor: const Color(0xFF00B894),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        cardColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'PingFang SC, Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2D3436)),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2D3436)),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF2D3436)),
          bodyMedium: TextStyle(color: Color(0xFF2D3436)),
        ),
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
