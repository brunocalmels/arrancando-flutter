import 'package:arrancando/config/state/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownSelect extends StatelessWidget {
  final String label;
  final String hint;
  final dynamic value;
  final List<Map<String, dynamic>> items;
  final Function(dynamic) onChanged;

  DropdownSelect({
    @required this.label,
    @required this.hint,
    @required this.value,
    @required this.items,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Color(Provider.of<MainState>(context).activeTheme ==
                            ThemeMode.light
                        ? 0xffcccccc
                        : 0xff1a1c28),
                    offset: Offset(0.0, 0.0),
                  ),
                  BoxShadow(
                    color: Color(Provider.of<MainState>(context).activeTheme ==
                            ThemeMode.light
                        ? 0xffeeeeee
                        : 0xff2d3548),
                    offset: Offset(0.0, 0.0),
                    spreadRadius: -12.0,
                    blurRadius: 12.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Theme(
                  data: ThemeData(
                    canvasColor: Theme.of(context).backgroundColor,
                    textTheme: Theme.of(context).textTheme,
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      hint,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .color
                            .withAlpha(150),
                      ),
                    ),
                    value: value,
                    onChanged: onChanged,
                    items: items
                        .map(
                          (i) => DropdownMenuItem(
                            value: i['value'],
                            child: Text(
                              i['label'],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
