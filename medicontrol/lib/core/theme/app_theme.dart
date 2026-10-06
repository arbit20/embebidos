import 'package:flutter/material.dart';

/// Paleta tomada de la figura de pantallas de MediControl.
abstract final class AppColors {
  static const azul = Color(0xFF1B6FD6);
  static const azulOscuro = Color(0xFF16324F);
  static const azulSuave = Color(0xFFE7F1FC);
  static const fondo = Color(0xFFF4F8FC);
  static const texto = Color(0xFF16324F);
  static const textoSuave = Color(0xFF5C6B7A);
  static const borde = Color(0xFFE3EAF2);
  static const exito = Color(0xFF1B8A5A);
}

ThemeData appTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.azul,
    primary: AppColors.azul,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.fondo,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.fondo,
      foregroundColor: AppColors.texto,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.azulSuave,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.azul : AppColors.textoSuave,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.azul : AppColors.textoSuave,
        );
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borde),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.borde),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.azul, width: 1.6),
      ),
      labelStyle: const TextStyle(color: AppColors.textoSuave),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        backgroundColor: AppColors.azul,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.azul,
      foregroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
