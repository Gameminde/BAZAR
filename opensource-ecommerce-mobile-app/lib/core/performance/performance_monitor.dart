/*
 * BAZAR Marketplace - Performance Monitor
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();
  
  int _frameCount = 0;
  int _droppedFrames = 0;
  DateTime _lastFrameTime = DateTime.now();
  List<double> _fpsHistory = [];
  StreamController<PerformanceMetrics>? _metricsController;
  
  Stream<PerformanceMetrics> get metricsStream {
    _metricsController ??= StreamController<PerformanceMetrics>.broadcast();
    return _metricsController!.stream;
  }
  
  void startMonitoring() {
    SchedulerBinding.instance.addPersistentFrameCallback(_onFrame);
    debugPrint('🎯 Performance monitoring started');
  }
  
  void stopMonitoring() {
    SchedulerBinding.instance.removePersistentFrameCallback(_onFrame);
    debugPrint('⏹️ Performance monitoring stopped');
  }
  
  void _onFrame(Duration timestamp) {
    _frameCount++;
    final now = DateTime.now();
    final frameDuration = now.difference(_lastFrameTime);
    
    // Calculer FPS
    final fps = 1000 / frameDuration.inMilliseconds;
    _fpsHistory.add(fps);
    
    // Garder seulement les 60 dernières valeurs
    if (_fpsHistory.length > 60) {
      _fpsHistory.removeAt(0);
    }
    
    // Détecter les frames lentes (< 16ms = 60fps)
    if (frameDuration.inMilliseconds > 16) {
      _droppedFrames++;
    }
    
    _lastFrameTime = now;
    
    // Émettre les métriques
    _metricsController?.add(PerformanceMetrics(
      fps: fps,
      averageFps: _fpsHistory.reduce((a, b) => a + b) / _fpsHistory.length,
      droppedFrames: _droppedFrames,
      frameCount: _frameCount,
      timestamp: now,
    ));
    
    // Alerte si performance dégradée
    if (fps < 50) {
      debugPrint('⚠️ Performance warning: FPS dropped to ${fps.toStringAsFixed(1)}');
    }
  }
  
  PerformanceReport generateReport() {
    final averageFps = _fpsHistory.isEmpty 
        ? 0 
        : _fpsHistory.reduce((a, b) => a + b) / _fpsHistory.length;
    
    final droppedFrameRate = _frameCount > 0 
        ? (_droppedFrames / _frameCount) * 100 
        : 0;
    
    return PerformanceReport(
      averageFps: averageFps,
      droppedFrameRate: droppedFrameRate,
      totalFrames: _frameCount,
      droppedFrames: _droppedFrames,
      isOptimal: averageFps >= 55 && droppedFrameRate < 5,
    );
  }
}

class PerformanceMetrics {
  final double fps;
  final double averageFps;
  final int droppedFrames;
  final int frameCount;
  final DateTime timestamp;
  
  PerformanceMetrics({
    required this.fps,
    required this.averageFps,
    required this.droppedFrames,
    required this.frameCount,
    required this.timestamp,
  });
}

class PerformanceReport {
  final double averageFps;
  final double droppedFrameRate;
  final int totalFrames;
  final int droppedFrames;
  final bool isOptimal;
  
  PerformanceReport({
    required this.averageFps,
    required this.droppedFrameRate,
    required this.totalFrames,
    required this.droppedFrames,
    required this.isOptimal,
  });
  
  @override
  String toString() {
    return """
Performance Report:
  Average FPS: ${averageFps.toStringAsFixed(1)}
  Dropped Frame Rate: ${droppedFrameRate.toStringAsFixed(1)}%
  Total Frames: $totalFrames
  Dropped Frames: $droppedFrames
  Status: ${isOptimal ? "✅ Optimal" : "⚠️ Needs Optimization"}
""";
  }
}