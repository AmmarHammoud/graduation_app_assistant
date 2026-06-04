import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// A simple application logger that writes to console and to a file.
class AppLogger {
  AppLogger._();

  static final AppLogger _instance = AppLogger._();
  static AppLogger get instance => _instance;

  late final Logger _logger;
  File? _logFile;

  static Future<void> init() async {
    await instance._init();
  }

  Future<void> _init() async {
    // Pretty printer for console
    _logger = Logger(
      printer: PrettyPrinter(methodCount: kDebugMode ? 2 : 0),
    );

    try {
      final dir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${dir.path}/logs');
      if (!await logDir.exists()) await logDir.create(recursive: true);
      _logFile = File('${logDir.path}/app.log');
      if (!await _logFile!.exists()) await _logFile!.create();
      info('AppLogger initialized. Log file: ${_logFile!.path}');
    } catch (e, st) {
      // If path_provider not available (e.g., tests), just continue with console logging
      _logger.w('Failed to initialize file logging: $e');
      _logFile = null;
    }
  }

  void _writeToFile(String text) {
    try {
      if (_logFile != null) {
        _logFile!.writeAsStringSync('${DateTime.now().toIso8601String()} $text\n', mode: FileMode.append, flush: true);
      }
    } catch (_) {
      // ignore file write errors
    }
  }

  void info(String message, [Map<String, dynamic>? extra]) {
    _logger.i(message, extra);
    _writeToFile('[INFO] $message ${extra ?? ''}');
  }

  void debug(String message, [Map<String, dynamic>? extra]) {
    _logger.d(message, extra);
    _writeToFile('[DEBUG] $message ${extra ?? ''}');
  }

  void warn(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error, stackTrace);
    _writeToFile('[WARN] $message ${error ?? ''}');
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error, stackTrace);
    _writeToFile('[ERROR] $message ${error ?? ''}');
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppLogger.instance.debug('Bloc/Cubit created: ${bloc.runtimeType}');
  }

  @override
  void onClose(BlocBase bloc) {
    AppLogger.instance.debug('Bloc/Cubit closed: ${bloc.runtimeType}');
    super.onClose(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.instance.info('onChange ${bloc.runtimeType}: $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppLogger.instance.info('onTransition ${bloc.runtimeType}: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.instance.error('onError in ${bloc.runtimeType}', error, stackTrace);
  }
}

