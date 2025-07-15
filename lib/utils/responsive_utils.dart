import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Screen size breakpoints
  static const double _smallScreenWidth = 375.0; // iPhone Mini
  static const double _mediumScreenWidth = 414.0; // iPhone Pro
  static const double _largeScreenWidth = 600.0; // Large phones/small tablets

  /// Get the current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < _mediumScreenWidth) return ScreenSize.small;
    if (width < _largeScreenWidth) return ScreenSize.medium;
    return ScreenSize.large;
  }

  /// Calculate responsive font size based on screen width
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = (screenWidth / _mediumScreenWidth).clamp(0.75, 1.4);
    return (baseSize * scaleFactor).roundToDouble();
  }

  /// Calculate adaptive font size that fits within available width
  static double getAdaptiveFontSize(
    BuildContext context, {
    required double baseSize,
    required double availableWidth,
    required String text,
    double minSize = 12.0,
  }) {
    final responsiveSize = getResponsiveFontSize(context, baseSize);

    // Test if text fits at responsive size
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: responsiveSize, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    if (textPainter.width <= availableWidth) {
      return responsiveSize;
    }

    // Scale down until it fits or reaches minimum
    double fontSize = responsiveSize;
    while (fontSize > minSize && textPainter.width > availableWidth) {
      fontSize -= 1.0;
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      );
      textPainter.layout();
    }

    return fontSize.clamp(minSize, responsiveSize);
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(
    BuildContext context,
    EdgeInsets basePadding,
  ) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return basePadding * 0.75;
      case ScreenSize.medium:
        return basePadding;
      case ScreenSize.large:
        return basePadding * 1.25;
    }
  }

  /// Calculate HintDisplay size that ensures 3 fit in a row with spacing
  static Size getHintDisplaySize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = getResponsivePadding(context, const EdgeInsets.all(16.0));
    final availableWidth = screenWidth - (padding.horizontal);

    // Leave space between hint displays (2 gaps of 8px each)
    final spacingWidth = 16.0;
    final hintDisplayWidth = ((availableWidth - spacingWidth) / 3)
        .floor()
        .toDouble();

    // Keep aspect ratio roughly 5:6 (width:height)
    final hintDisplayHeight = (hintDisplayWidth * 1.2).clamp(100.0, 140.0);

    return Size(hintDisplayWidth, hintDisplayHeight);
  }

  /// Get responsive spacing based on screen size
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return baseSpacing * 0.6;
      case ScreenSize.medium:
        return baseSpacing;
      case ScreenSize.large:
        return baseSpacing * 1.3;
    }
  }

  /// Calculate round button size based on screen
  static double getRoundButtonSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseSize = 120.0;
    final scaleFactor = (screenWidth / _mediumScreenWidth).clamp(0.8, 1.2);
    return (baseSize * scaleFactor).clamp(90.0, 140.0);
  }

  /// Calculate correct digit container height based on font size
  static double getCorrectDigitHeight(BuildContext context, double fontSize) {
    // Height should accommodate the font size plus some padding
    return (fontSize * 1.4).clamp(30.0, 60.0);
  }

  /// Get available height for main content area
  static double getMainContentHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return screenHeight - appBarHeight - statusBarHeight - bottomPadding;
  }
}

enum ScreenSize { small, medium, large }
