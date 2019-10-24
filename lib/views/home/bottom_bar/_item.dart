import 'package:flutter/material.dart';

class BBButtonItem extends StatefulWidget {
  final int activeItem;
  final int index;
  final BBItem item;
  final Function setActiveItem;

  BBButtonItem({
    this.activeItem,
    this.index,
    this.item,
    this.setActiveItem,
  });

  @override
  _BBButtonItemState createState() => _BBButtonItemState();
}

class _BBButtonItemState extends State<BBButtonItem> {
  double _width = 0;

  _setTextAnimation() async {
    _width =
        widget.activeItem == widget.index ? widget.item.text.length * 8.0 : 0;
    setState(() {});
    if (_width > 0) {
      await Future.delayed(Duration(milliseconds: 1500));
      _width = 0;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _setTextAnimation();
  }

  @override
  void didUpdateWidget(BBButtonItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setTextAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Material(
        color: Colors.transparent,
        type: MaterialType.circle,
        child: InkWell(
          onTap: () => widget.setActiveItem(widget.index),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  widget.item.icon,
                  color: widget.activeItem == widget.index
                      ? Theme.of(context).primaryColor
                      : null,
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: _width,
                child: Text(
                  widget.item.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BBItem {
  IconData icon;
  String text;

  BBItem({
    @required this.icon,
    @required this.text,
  });
}
