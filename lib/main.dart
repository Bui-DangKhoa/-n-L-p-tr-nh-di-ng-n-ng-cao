import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // ✅ Thêm import firebase options
import 'providers/auth_provider.dart'; // ✅ Chuyển lại về auth provider chính
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart'; // 🆕 Wishlist provider
import 'providers/notification_provider.dart'; // 🆕 Notification provider
import 'providers/address_provider.dart'; // 🆕 Address provider
import 'providers/banner_provider.dart';
import 'providers/brand_provider.dart';
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
import 'screens/debug/admin_setup_screen.dart'; // ✅ Thêm import admin setup screen
import 'screens/debug/quick_admin_fix.dart'; // ✅ Thêm import quick admin fix
import 'screens/debug/seed_data_screen.dart'; // ✅ Thêm import seed data screen
import 'screens/admin/product_management_screen.dart'; // ✅ Thêm import admin screens
import 'screens/admin/add_edit_product_screen.dart'; // ✅ Thêm import add/edit product screen
import 'screens/admin/coupon_management_screen.dart';
import 'screens/admin/brand_management_screen.dart';
import 'screens/admin/banner_management_screen.dart';
import 'screens/wishlist/wishlist_screen.dart'; // 🆕 Thêm import wishlist screen
import 'screens/category/category_management_screen.dart'; // 🆕 Thêm import category management screen
import 'screens/address/address_screen.dart'; // 🆕 Thêm import address screen
import 'screens/notification/notification_screen.dart'; // 🆕 Thêm import notification screen
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
        ChangeNotifierProvider(
          create: (_) => WishlistProvider(),
        ), // 🆕 Wishlist
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ), // 🆕 Notification
        ChangeNotifierProvider(create: (_) => AddressProvider()), // 🆕 Address
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
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
        '/admin-setup': (context) =>
            const AdminSetupScreen(), // ✅ Thêm admin setup route
        '/quick-admin-fix': (context) =>
            const QuickAdminFix(), // ✅ Thêm quick admin fix route
        '/seed-data': (context) =>
            const SeedDataScreen(), // ✅ Thêm seed data route
        '/admin/products': (context) =>
            const ProductManagementScreen(), // ✅ Thêm admin product management route
        '/admin/add-product': (context) =>
            const AddEditProductScreen(), // ✅ Thêm add product route
        '/admin/coupons': (context) => const CouponManagementScreen(),
        '/admin/brands': (context) => const BrandManagementScreen(),
        '/admin/banners': (context) => const BannerManagementScreen(),
        '/wishlist': (context) =>
            const WishlistScreen(), // 🆕 Thêm wishlist route
        '/category-management': (context) =>
            const CategoryManagementScreen(), // 🆕 Thêm category management route
        '/addresses': (context) =>
            const AddressScreen(), // 🆕 Thêm addresses route
        '/notifications': (context) =>
            const NotificationScreen(), // 🆕 Thêm notifications route
      },
    );
  }
}
