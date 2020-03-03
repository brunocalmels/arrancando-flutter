import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BBButtonItem extends StatefulWidget {
  final BBItem item;
  final Function setSearchVisibility;

  BBButtonItem({
    this.item,
    this.setSearchVisibility,
  });

  @override
  _BBButtonItemState createState() => _BBButtonItemState();
}

class _BBButtonItemState extends State<BBButtonItem> {
  double _width = 0;

  _setTextAnimation() async {
    _width = Provider.of<MainState>(context).activePageHome == widget.item.value
        ? widget.item.text.length * 8.0
        : 0;
    if (mounted) setState(() {});
    // if (_width > 0) {
    //   await Future.delayed(Duration(milliseconds: 1000));
    //   _width = 0;
    //   if (mounted) setState(() {});
    // }
  }

  _stopTextAnimation() async {
    _width = 0;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setTextAnimation();
    });
  }

  @override
  void didUpdateWidget(BBButtonItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Provider.of<MainState>(context).activePageHome == widget.item.value)
      _setTextAnimation();
    else
      _stopTextAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Material(
        color: Colors.transparent,
        type: MaterialType.circle,
        child: InkWell(
          onTap: () {
            widget.setSearchVisibility(false);
            Provider.of<MainState>(context, listen: false)
                .setActivePageHome(widget.item.value);
          },
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  widget.item.icon,
                  color: Provider.of<MainState>(context).activePageHome ==
                          widget.item.value
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
  SectionType value;

  BBItem({
    @required this.icon,
    @required this.text,
    @required this.value,
  });
}
