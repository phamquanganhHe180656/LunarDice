import 'package:flutter/material.dart';
import '../../shared/constants/app_constants.dart';

/// A layout helper that provides a different builder for mobile and desktop.
///
/// Usage:
/// ```dart
/// ResponsiveLayout(
///   mobile: MobileWidget(),
///   desktop: DesktopWidget(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.desktop,
    this.tablet,
  });

  final Widget mobile;
  final Widget desktop;

  /// Optional tablet layout. Falls back to [mobile] if not provided.
  final Widget? tablet;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppConstants.mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppConstants.desktopBreakpoint;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= AppConstants.desktopBreakpoint) {
      return desktop;
    } else if (width >= AppConstants.mobileBreakpoint) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }
}
