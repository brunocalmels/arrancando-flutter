import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImageIconShadowWidget extends StatelessWidget {
  final ImageIcon icon;
  final bool showShadow;
  final Color shadowColor;

  ImageIconShadowWidget(
    this.icon, {
    this.showShadow = true,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    double opacity = 0.1;
    double opacity2 = 0.01;
    double opacity3 = 0.01;
    double dimens = 0;
    double dimens2 = 0;
    double dimens3 = 0;
    Color _shadowColor = icon.color;
    if (shadowColor != null) _shadowColor = shadowColor;
    List<Widget> list = new List();
    if (showShadow) {
      list.addAll([
        Positioned(
          bottom: dimens3,
          right: dimens3,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity3,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        ),
        Positioned(
          bottom: dimens3,
          left: dimens3,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity3,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        ),
        Positioned(
          top: dimens3,
          left: dimens3,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity3,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        ),
        Positioned(
          top: dimens3,
          right: dimens3,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity3,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        )
      ]);

      list.addAll([
        Positioned(
          bottom: dimens2,
          right: dimens2,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity2,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        ),
        Positioned(
          bottom: dimens2,
          left: dimens2,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity2,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        ),
        Positioned(
          top: dimens2,
          left: dimens2,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity2,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        ),
        Positioned(
          top: dimens2,
          right: dimens2,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity2,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        )
      ]);

      list.addAll([
        Positioned(
          bottom: dimens,
          right: dimens,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        ),
        Positioned(
          bottom: dimens,
          left: dimens,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        ),
        Positioned(
          top: dimens,
          left: dimens,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        ),
        Positioned(
          top: dimens,
          right: dimens,
          child: IconTheme(
              data: IconThemeData(
                opacity: opacity,
              ),
              child: ImageIcon(
                icon.image,
                key: icon.key,
                color: _shadowColor,
                size: icon.size,
                semanticLabel: icon.semanticLabel,
              )),
        )
      ]);
    }

    list.add(ClipRect(
        child: BackdropFilter(
      filter: new ui.ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
      child: IconTheme(data: IconThemeData(opacity: 1.0), child: icon),
    )));

    list.add(IconTheme(data: IconThemeData(opacity: 1.0), child: icon));

    return Stack(
      alignment: Alignment.center,
      children: list,
    );
  }
}
