import 'package:flutter/material.dart';

class CustomAnimations {
  // Animation d'explosion (comme dans l'original)
  static AnimationController createExplosionController(TickerProvider vsync) {
    return AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
  }

  static Animation<double> createExplosionAnimation(
    AnimationController controller,
  ) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.1, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut));
  }

  // Animation de scale pour les boutons
  static AnimationController createButtonScaleController(TickerProvider vsync) {
    return AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: vsync,
    );
  }

  static Animation<double> createButtonScaleAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  // Animation de fade in
  static AnimationController createFadeInController(TickerProvider vsync) {
    return AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );
  }

  static Animation<double> createFadeInAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
  }

  // Animation de slide up
  static AnimationController createSlideUpController(TickerProvider vsync) {
    return AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: vsync,
    );
  }

  static Animation<Offset> createSlideUpAnimation(
    AnimationController controller,
  ) {
    return Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
  }
}
