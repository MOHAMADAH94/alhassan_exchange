  import 'package:flutter/material.dart';
  import 'screens/home_screen.dart';
  import 'screens/branches_screen.dart';
  import 'screens/calculator_screen.dart';
  import 'screens/about_screen.dart';


  void main() {
    runApp(const MyApp());
  }

  class MyApp extends StatefulWidget {
    const MyApp({super.key});

    @override
    State<MyApp> createState() => _MyAppState();
  }

  class _MyAppState extends State<MyApp> {
    int _selectedIndex = 0;

    static const goldenColor = Color(0xFFFFD700);
    static const darkColor = Color(0xFF121212);

    final List<Widget> _screens = [
      const HomeScreen(),
      const BranchesScreen(),
      const CalculatorScreen(),
    ];

    void _showAboutDialog(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutScreen()),
      );
    }
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: darkColor,
          textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'ithra',
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 4,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              fontFamily: 'ithra',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: goldenColor,
            ),
            toolbarHeight: 90,
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('شركة الحسان للصرافة'),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.info_outline, size: 28, color: goldenColor),
                onPressed: () => _showAboutDialog(context),
              ),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/img/logo.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          body: _screens[_selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.black,
                selectedItemColor: goldenColor,
                unselectedItemColor: Colors.white60,
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled, size: 28),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.location_on, size: 28),
                    label: 'مراكزنا',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calculate, size: 28),
                    label: 'الحاسبة',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(
                  fontFamily: 'ithra',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'ithra',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }