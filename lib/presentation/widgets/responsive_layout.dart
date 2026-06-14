import 'package:flutter/material.dart';

import '../../constants.dart';

/// Layout information that describes the current screen size.
enum ScreenType {
  mobile,
  tablet,
  desktop,
}

ScreenType screenTypeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < Breakpoints.mobile) return ScreenType.mobile;
  if (width < Breakpoints.tablet) return ScreenType.tablet;
  return ScreenType.desktop;
}

bool isMobile(BuildContext context) =>
    screenTypeOf(context) == ScreenType.mobile;

bool isDesktop(BuildContext context) =>
    screenTypeOf(context) == ScreenType.desktop;
