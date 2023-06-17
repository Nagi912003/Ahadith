import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredContainer extends StatelessWidget {
  final double blurSigmaX;
  final double blurSigmaY;
  final Widget child;

  const BlurredContainer({
    Key? key,
    this.blurSigmaX = 20.0,
    this.blurSigmaY = 30.0,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blurSigmaX,
                sigmaY: blurSigmaY,
              ),
               child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
