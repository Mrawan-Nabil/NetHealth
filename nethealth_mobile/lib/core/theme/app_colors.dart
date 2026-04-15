import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand — Teal palette
  static const primary      = Color(0xFF0D9488); // Teal-600
  static const primaryDark  = Color(0xFF0F766E); // Teal-700
  static const primaryLight = Color(0xFF14B8A6); // Teal-500
  static const primaryFaint = Color(0xFFCCFBF1); // Teal-100

  // Surfaces — Light
  static const backgroundLight = Color(0xFFF8FAFC); // Slate-50
  static const surfaceLight    = Color(0xFFFFFFFF);
  static const cardLight       = Color(0xFFFFFFFF);
  static const borderLight     = Color(0xFFE2E8F0); // Slate-200

  // Surfaces — Dark
  static const backgroundDark = Color(0xFF0F172A); // Slate-900
  static const surfaceDark    = Color(0xFF1E293B); // Slate-800
  static const cardDark       = Color(0xFF1E293B);
  static const borderDark     = Color(0xFF334155); // Slate-700

  // Text — Light
  static const textPrimaryLight   = Color(0xFF0F172A); // Slate-900
  static const textSecondaryLight = Color(0xFF64748B); // Slate-500
  static const textHintLight      = Color(0xFF94A3B8); // Slate-400

  // Text — Dark
  static const textPrimaryDark   = Color(0xFFF1F5F9); // Slate-100
  static const textSecondaryDark = Color(0xFF94A3B8); // Slate-400
  static const textHintDark      = Color(0xFF64748B); // Slate-500

  // Semantic
  static const success      = Color(0xFF22C55E);
  static const successFaint = Color(0xFFDCFCE7);
  static const warning      = Color(0xFFF59E0B);
  static const warningFaint = Color(0xFFFEF3C7);
  static const error        = Color(0xFFEF4444);
  static const errorFaint   = Color(0xFFFEE2E2);
  static const info         = Color(0xFF3B82F6);
  static const infoFaint    = Color(0xFFDBEAFE);

  // Status chips
  static const statusScheduled  = Color(0xFF3B82F6);
  static const statusCompleted  = Color(0xFF22C55E);
  static const statusCancelled  = Color(0xFFEF4444);
  static const statusPending    = Color(0xFFF59E0B);
  static const statusIssued     = Color(0xFF0D9488);
  static const statusDispensed  = Color(0xFF8B5CF6);
}
