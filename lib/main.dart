import 'package:expense_track/providers/bottom_nav_provider.dart';
import 'package:expense_track/providers/expensepage_provider.dart';
import 'package:expense_track/providers/loginsignup_provider.dart';
import 'package:expense_track/providers/profile_provider.dart';
import 'package:expense_track/providers/transaction_provider.dart';
import 'package:expense_track/screens/homescreen.dart';
import 'package:expense_track/screens/loginsignupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => BottomNavProvider()),
    ChangeNotifierProvider(create: (context) => LoginSignupProvider()),
    ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ChangeNotifierProvider(create: (context) => TransactionProvider()),
    ChangeNotifierProvider(create: (context) => ExpensePageProvider()),

  ], child: MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(user?.uid);

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Track',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
    title: 'Expense Track',
    theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    ),
    home: user == null ? LoginSignupPage() : MyHomePage(),
    ),
    );
  }
}

