import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // ✅ Thêm import firebase options
import 'providers/auth_provider.dart'; // ✅ Chuyển lại về auth provider chính
import 'providers/cart_provider.dart';
import 'screens/auth/login_screen.dart'; // ✅ Thêm import
import 'screens/auth/register_screen.dart'; // ✅ Thêm import
import 'screens/home/home_screen.dart'; // ✅ Thêm import
import 'screens/cart/cart_screen.dart'; // ✅ Thêm import cart screen
import 'screens/category/category_screen.dart'; // ✅ Thêm import category screen
import 'screens/search/search_screen.dart'; // ✅ Thêm import search screen
import 'screens/account/account_screen.dart'; // ✅ Thêm import account screen
import 'screens/account/edit_profile_screen.dart'; // ✅ Thêm import edit profile screen
import 'screens/account/change_password_screen.dart'; // ✅ Thêm import change password screen
import 'screens/debug/firebase_debug_screen.dart'; // ✅ Thêm import debug screen
// import 'services/firestore_service.dart'; // ❌ Tạm thời tắt

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ), // ✅ Chuyển lại về auth provider chính
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
      title: 'Shopping App',
      debugShowCheckedModeBanner: false, // Ẩn banner debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Dùng Material 3
      ),
      initialRoute: '/login', // Chuyển về login screen chính
      onGenerateRoute: (settings) {
        // Handle dynamic routes with parameters
        if (settings.name!.startsWith('/category/')) {
          final categoryName = settings.name!.split('/category/')[1];
          return MaterialPageRoute(
            builder: (context) => CategoryScreen(categoryName: categoryName),
          );
        }
        return null;
      },
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(), // ✅ Thêm cart route
        '/search': (context) => const SearchScreen(), // ✅ Thêm search route
        '/account': (context) => const AccountScreen(), // ✅ Thêm account route
        '/edit-profile': (context) =>
            const EditProfileScreen(), // ✅ Thêm edit profile route
        '/change-password': (context) =>
            const ChangePasswordScreen(), // ✅ Thêm change password route
        '/firebase-debug': (context) =>
            const FirebaseDebugScreen(), // ✅ Thêm debug route
      },
    );
  }
}
