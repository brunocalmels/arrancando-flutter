import 'package:flutter/material.dart';

class FirstItemIndicator extends StatefulWidget {
  final int id;
  final Map<int, GlobalKey> firstItemGlobalKeys;
  final Function(int, GlobalKey) addFirstItemGlobalKey;

  const FirstItemIndicator({
    Key key,
    @required this.id,
    @required this.firstItemGlobalKeys,
    @required this.addFirstItemGlobalKey,
  }) : super(key: key);

  @override
  _FirstItemIndicatorState createState() => _FirstItemIndicatorState();
}

class _FirstItemIndicatorState extends State<FirstItemIndicator> {
  final _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.firstItemGlobalKeys[widget.id] == null &&
          _globalKey.currentContext != null) {
        widget.addFirstItemGlobalKey(widget.id, _globalKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _globalKey,
    );
  }
}
