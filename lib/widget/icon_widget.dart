import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconWidget extends StatelessWidget {
  final String _iconPath;
  final bool _isSelected;

  IconWidget(this._iconPath, this._isSelected);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.all(2),
      child: SvgPicture.asset(_iconPath, height: 48),
      // fillColor: _isSelected ? Colors.amber[200] : Colors.transparent,
      shape: CircleBorder(),
      onPressed: null,
    );
  }
}
