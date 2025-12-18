import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart' as auth;
import 'providers/calorie_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  print('=== MAIN STARTING ===');
  WidgetsFlutterBinding.ensureInitialized();
  print('=== FLUTTER BINDING INITIALIZED ===');
  
  try {
    print('=== INITIALIZING FIREBASE ===');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('=== Firebase initialized successfully ===');
  } catch (e, stackTrace) {
    print('=== Firebase initialization error: $e ===');
    print('Stack trace: $stackTrace');
  }
  
  print('=== RUNNING APP ===');
  runApp(const MyApp());
  print('=== APP STARTED ===');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => auth.UserAuthProvider()),
        ChangeNotifierProvider(create: (_) => CalorieProvider()),
      ],
      child: MaterialApp(
        title: 'Calorie Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

// Widget to handle authentication state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    print('AuthWrapper building...');
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print('Auth state: ${snapshot.connectionState}, hasData: ${snapshot.hasData}');
        
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('Showing loading indicator');
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            ),
          );
        }
        
        // Show HomeScreen if authenticated, otherwise AuthScreen
        if (snapshot.hasData) {
          print('User authenticated, showing HomeScreen');
          return const HomeScreen();
        } else {
          print('User not authenticated, showing AuthScreen');
          return const AuthScreen();
        }
      },
    );
  }
}
