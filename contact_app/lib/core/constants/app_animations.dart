import 'package:flutter/material.dart';

class AppAnimations {
  // Animation Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  // Animation Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeOutCubic;
  
  // Stagger Delays
  static const Duration staggerDelay = Duration(milliseconds: 50);
  
  // Scale values
  static const double scaleMin = 0.95;
  static const double scaleMax = 1.0;
  
  // Slide offsets
  static const Offset slideFromRight = Offset(1.0, 0.0);
  static const Offset slideFromLeft = Offset(-1.0, 0.0);
  static const Offset slideFromBottom = Offset(0.0, 1.0);
  static const Offset slideCenter = Offset.zero;
}
