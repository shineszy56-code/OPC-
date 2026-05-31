import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App 全局状态
final appStateProvider = Provider<AppState>((ref) {
  return AppState();
});

/// App 全局状态类
class AppState {
  /// 当前主题模式
  final ThemeMode themeMode;

  /// 是否启用生物识别
  final bool biometricEnabled;

  /// 当前语言代码
  final String languageCode;

  /// 是否显示操作日志时间线
  final bool showOperationLog;

  const AppState({
    this.themeMode = ThemeMode.dark,
    this.biometricEnabled = false,
    this.languageCode = 'zh',
    this.showOperationLog = true,
  });

  /// 复制并修改状态
  AppState copyWith({
    ThemeMode? themeMode,
    bool? biometricEnabled,
    String? languageCode,
    bool? showOperationLog,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      languageCode: languageCode ?? this.languageCode,
      showOperationLog: showOperationLog ?? this.showOperationLog,
    );
  }
}

/// App 状态 Notifier
final appStateNotifierProvider = NotifierProvider<AppStateNotifier, AppState>(
  AppStateNotifier.new,
);

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    return const AppState();
  }

  /// 切换主题模式
  void toggleThemeMode() {
    state = state.copyWith(
      themeMode: state.themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark,
    );
  }

  /// 设置主题模式
  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  /// 切换生物识别
  void toggleBiometric() {
    state = state.copyWith(biometricEnabled: !state.biometricEnabled);
  }

  /// 设置语言
  void setLanguage(String languageCode) {
    state = state.copyWith(languageCode: languageCode);
  }

  /// 切换操作日志显示
  void toggleOperationLog() {
    state = state.copyWith(showOperationLog: !state.showOperationLog);
  }
}
