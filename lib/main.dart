import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_train/pages/ft_challenge_mode_select/ft_challenge_mode_select_binding.dart';
import 'package:focus_train/pages/ft_challenge_mode_select/ft_challenge_mode_select_view.dart';
import 'package:focus_train/pages/ft_crazy_mode_select/ft_crazy_mode_select_binding.dart';
import 'package:focus_train/pages/ft_crazy_mode_select/ft_crazy_mode_select_view.dart';
import 'package:focus_train/pages/ft_daily_listen/ft_daily_listen_binding.dart';
import 'package:focus_train/pages/ft_daily_listen/ft_daily_listen_view.dart';
import 'package:focus_train/pages/ft_home/ft_home_binding.dart';
import 'package:focus_train/pages/ft_home/ft_home_view.dart';
import 'package:focus_train/pages/ft_kids_mode_select/ft_kids_mode_select_binding.dart';
import 'package:focus_train/pages/ft_kids_mode_select/ft_kids_mode_select_view.dart';
import 'package:focus_train/pages/ft_listen_categorize/ft_listen_categorize_binding.dart';
import 'package:focus_train/pages/ft_listen_categorize/ft_listen_categorize_view.dart';
import 'package:focus_train/pages/ft_listen_repeat/ft_listen_repeat_binding.dart';
import 'package:focus_train/pages/ft_listen_repeat/ft_listen_repeat_view.dart';
import 'package:focus_train/pages/ft_listen_reverse/ft_listen_reverse_binding.dart';
import 'package:focus_train/pages/ft_listen_reverse/ft_listen_reverse_view.dart';
import 'package:focus_train/pages/ft_listening_menu/ft_listening_menu_binding.dart';
import 'package:focus_train/pages/ft_listening_menu/ft_listening_menu_view.dart';
import 'package:focus_train/pages/ft_main/ft_main_binding.dart';
import 'package:focus_train/pages/ft_main/ft_main_view.dart';
import 'package:focus_train/pages/ft_number_game/ft_number_game_binding.dart';
import 'package:focus_train/pages/ft_number_game/ft_number_game_view.dart';
import 'package:focus_train/pages/ft_poetry_game/ft_poetry_game_binding.dart';
import 'package:focus_train/pages/ft_poetry_game/ft_poetry_game_view.dart';
import 'package:focus_train/pages/ft_poetry_list/ft_poetry_list_binding.dart';
import 'package:focus_train/pages/ft_poetry_list/ft_poetry_list_view.dart';
import 'package:focus_train/pages/ft_settings/ft_settings_binding.dart';
import 'package:focus_train/pages/ft_settings/ft_settings_view.dart';
import 'package:focus_train/pages/ft_standard/ft_standard_binding.dart';
import 'package:focus_train/pages/ft_standard/ft_standard_view.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF9333EA);
const Color bgColor = Color(0xFFF8FAFC);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'FocusTrain',
          debugShowCheckedModeBanner: false,
          initialRoute: '/ft_main',
          getPages: FocusPro,
          theme: _buildTheme(),
        );
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: const Color(0xFF8B5CF6),
        surface: const Color(0xFFFFFFFF),
        error: const Color(0xFFEF4444),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 48,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1F2937),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color(0xFF1F2937),
        ),
        iconTheme: IconThemeData(size: 24, color: Color(0xFF1F2937)),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF9CA3AF),
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: Colors.grey.shade200,
      ),
      fontFamily: '-apple-system, BlinkMacSystemFont, Segoe UI',
    );
  }
}
List<GetPage<dynamic>> FocusPro = [
  GetPage(
    name: '/ft_main',
    page: () => const FtMainView(),
    binding: FtMainBinding(),
  ),
  GetPage(
    name: '/ft_home',
    page: () => const FtHomeView(),
    binding: FtHomeBinding(),
  ),
  GetPage(
    name: '/ft_standard_mode',
    page: () => const FtStandardView(),
    binding: FtStandardBinding(),
  ),
  GetPage(
    name: '/ft_kids_mode',
    page: () => const FtKidsModeSelectView(),
    binding: FtKidsModeSelectBinding(),
  ),
  GetPage(
    name: '/ft_number_game',
    page: () => const FtNumberGameView(),
    binding: FtNumberGameBinding(),
  ),
  GetPage(
    name: '/ft_challenge_mode',
    page: () => const FtChallengeModeSelectView(),
    binding: FtChallengeModeSelectBinding(),
  ),
  GetPage(
    name: '/ft_crazy_mode',
    page: () => const FtCrazyModeSelectView(),
    binding: FtCrazyModeSelectBinding(),
  ),
  GetPage(
    name: '/ft_poetry_mode',
    page: () => const FtPoetryListView(),
    binding: FtPoetryListBinding(),
  ),
  GetPage(
    name: '/ft_poetry_mode/game',
    page: () => const FtPoetryGameView(),
    binding: FtPoetryGameBinding(),
  ),
  GetPage(
    name: '/ft_listening_training',
    page: () => const FtListeningMenuView(),
    binding: FtListeningMenuBinding(),
  ),
  GetPage(
    name: '/ft_listening_training/repeat',
    page: () => const FtListenRepeatView(),
    binding: FtListenRepeatBinding(),
  ),
  GetPage(
    name: '/ft_listening_training/reverse',
    page: () => const FtListenReverseView(),
    binding: FtListenReverseBinding(),
  ),
  GetPage(
    name: '/ft_listening_training/categorize',
    page: () => const FtListenCategorizeView(),
    binding: FtListenCategorizeBinding(),
  ),
  GetPage(
    name: '/ft_daily_listen',
    page: () => const FtDailyListenView(),
    binding: FtDailyListenBinding(),
  ),
  GetPage(
    name: '/ft_settings',
    page: () => const FtSettingsView(),
    binding: FtSettingsBinding(),
  ),
];